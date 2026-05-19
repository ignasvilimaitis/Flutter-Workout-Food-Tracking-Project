import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// Widgets
import '../../workout_base.dart' show CustomAppBarExercisesDetails;
import './muscle_anatomy.dart' show MuscleAnatomy, MuscleAnatomyController;

// Data
import '../../../data/workout_repository.dart';
import '../../../data/workout_model.dart' show Exercise, VariantMuscle, Variation;
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
    final defaultVariation = variations.firstWhere((v) => v.isDefault);
    final muscleMap = await exerciseRepo.fetchExerciseMuscles(widget.exercise.id);

    return {
      'variations': variations,
      'muscleMap': muscleMap,
      'defaultVariation': defaultVariation
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
          final muscleMap = data['muscleMap'] as Map<int, Map<String, List<VariantMuscle>>>;
          final selectedVariantMuscleMap = muscleMap[selectedVariation.id]!;
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
                        muscles: selectedVariantMuscleMap,
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
  final Map<String, List<VariantMuscle>> muscles;

  const AboutTab({super.key, required this.variation, required this.muscles});

  @override
  Widget build(BuildContext context) {

    /// Intialise the muscleAnatomy SVG element
    final List<VariantMuscle> muscleList = muscles.values.expand((list) => list).toList();
    final MuscleAnatomyController muscleAnatomyController = MuscleAnatomyController();
    final MuscleAnatomy muscleAnatomy = 
      MuscleAnatomy(
        muscles: muscleList, 
        showFlipButton: false,
        controller: muscleAnatomyController,
      );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 8,
        children: [
          if (variation.notes != null && variation.notes!.isNotEmpty)
          // Notes section
          _buildNotesSection(variation.notes),
      
          // Muscle breakdown & about row
          Flexible(
            flex: 4,
            child: _buildAboutRow(variation.about, muscleAnatomy)
          ),
      
          // Muscle breakdown cards
          Flexible(
            flex: 1,
            child: _buildMuscleCards(muscles, muscleAnatomyController)
          ),
      
          Divider(color: Colors.grey, radius: BorderRadius.circular(8), height: 1,),
      
          // Placeholder for future sections (e.g., exercise category, equipment, unit weight, max weight, etc.)
          Flexible(
            flex: 1,
            child: _buildAdditionalInfo()
          )
        ]
      ),
    );
  }

  Widget _buildNotesSection(String? notes) {
    return Container(
      padding: const EdgeInsets.all(4),
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
            notes.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          )
        ]
      )
    );
  }

  Widget _buildAboutRow(String? about, MuscleAnatomy muscleAnatomy) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Expanded(
          child: SizedBox.expand(
            child: muscleAnatomy
          ),
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
                textAlign: TextAlign.justify,
              ),
            ]
          )
        )
      ]
    );
  }

  Widget _buildMuscleCards(Map<String, List<VariantMuscle>> muscles, MuscleAnatomyController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            // Dynamically generate based on muscle map
            for (var entry in muscles.entries)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final page = entry.value.first.roleSequence! - 1;
                    controller.openDialogue(true, page: page);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      color: Colors.grey.shade100.withAlpha(100),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ..._buildMuscleList(entry.value, constraints.maxHeight)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ]
        );
      }
    );
  }

  /// Returns a dynamic list based on available height to prevent overflow
  List<Widget> _buildMuscleList(List<VariantMuscle?> muscles, double availableHeight) {
    final List<String?> cleanedMuscles = muscles.map((m) => m!.group).toSet().toList();

    const titleHeight = 22;
    const itemHeight = 17;
    const padding = 8;
    const moreIndicatorHeight = 14;

    final spaceForItems = availableHeight - titleHeight - padding;

    int itemsToShow = (spaceForItems / itemHeight).floor();
    if (cleanedMuscles.length > itemsToShow) {
      itemsToShow = ((spaceForItems - moreIndicatorHeight) / itemHeight).floor();
    }

    itemsToShow = itemsToShow.clamp(1, cleanedMuscles.length);

    final widgets = <Widget>[];

    for (var muscle in cleanedMuscles.take(itemsToShow)) {
      widgets.add(
        Text(
          muscle ?? 'Unnamed Muscle',
          style: TextStyle(
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );
    }

    if (cleanedMuscles.length > itemsToShow) {
      widgets.add(
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              '+${muscles.length - itemsToShow} more',
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildAdditionalInfo() {
    return Row(
      spacing: 4,
      children: [
        Expanded(
          child: Placeholder()
        ),
        Expanded(
          child: Placeholder()
        ),
        Expanded(
          child: Placeholder()
        ),
      ],
    );
  }
}