import 'package:flutter/material.dart';

// Widgets
import '../../workout_base.dart' show CustomAppBarExercisesDetails;

// Data
import '../../../data/workout_repository.dart';
import '../../../data/workout_model.dart' show Variation, Exercise;
import '../../../data/workout_data_source.dart' show ExerciseDataSource;

// ================================= Exercise Details =================================
class ExerciseDetails extends StatefulWidget {
  final Exercise exercise;
  const ExerciseDetails({super.key, required this.exercise});

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  late Variation selectedVariation;
  late final Future<Map<String, dynamic>> _exerciseFuture;

  Future<Map<String, dynamic>> _loadData() async {
    final exerciseRepo = ExerciseRepository(ExerciseDataSource());
    final variations = await exerciseRepo.fetchExerciseVariations(widget.exercise.id);
    final muscleGroups = await exerciseRepo.fetchExerciseMuscles(widget.exercise.id);
    final defaultVariation = variations.firstWhere((v) => v.isDefault);

    return {
      'variations': variations,
      'muscleGroups': muscleGroups,
      'defaultVariation': defaultVariation,
    };
  }

  @override
  void initState() {
    super.initState();
    _exerciseFuture = _loadData().then((data) {
      selectedVariation = data['defaultVariation'] as Variation;
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: FutureBuilder<Map<String, dynamic>>( //Use futurebuilder to prevent unassigned data due to async loading
        future: _exerciseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading exercise details'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          final muscleGroups = data['muscleGroups'] as Map<String, List>;
          final variations = data['variations'] as List<Variation>;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).primaryColor,
            appBar: CustomAppBarExercisesDetails(
              exerciseName: widget.exercise.name,
              selectedVariation: selectedVariation,
              variations: variations,
              onVariationChanged: (variation) {
                setState(() => selectedVariation = variation);
              },
            ),
            body: TabBarView(
              children: [
                // About
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).cardColor,
                      ),
                      child: AboutTab(
                        variation: selectedVariation, 
                        muscles: muscleGroups
                      ),
                    )
                  ),
                ),
          
                // History
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Placeholder()
                  ),
                ),
          
                // Charts
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Placeholder()
                  ),
                ),
          
                // Records
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Placeholder()
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AboutTab extends StatelessWidget {
  final Variation variation;
  final Map<String, List> muscles;

  const AboutTab({super.key, required this.variation, required this.muscles});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Notes section
          _buildNotesSection(variation.notes),
      
          // Muscle breakdown & about row
          _buildAboutRow(variation.about, muscles)
      
          // 
        ]
      ),
    );
  }

  Widget _buildNotesSection(String? notes) {
    if (notes == null || notes.isEmpty) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Color.fromARGB(200, 255, 217, 112),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Notes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold, 
                color: Colors.black54,
              ),
            ),
            Text(
              notes,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            )
          ]
        )
      ),
    );
  }

  Widget _buildAboutRow(String? about, Map<String, List> muscles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        spacing: 6,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              // Muscle Breakdown -- Currently placeholder
              Expanded(
                child: Placeholder()
              ),
          
              // About section
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      about ?? 'No description available.',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ]
                )
              )
            ]
          ),
          
          // Additional muscle breakdown
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamically generate based on muscle map
              for (var entry in muscles.entries)
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      for (var muscle in entry.value)
                        Text(
                          muscle,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
            ]
          ),
        ],
      ),
    );
  }
}