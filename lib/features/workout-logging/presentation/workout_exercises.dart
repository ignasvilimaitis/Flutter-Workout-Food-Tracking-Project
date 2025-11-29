import 'package:flutter/material.dart';

// Widgets
import 'workout_base.dart' show CustomAppBarExercises;

// Data
import '../data/workout_repository.dart';
import '../data/workout_model.dart' show Exercise;
import '../data/workout_data_source.dart' show ExerciseDataSource;

class WorkoutExercisesPage extends StatelessWidget {
  final VoidCallback? returnHome;

  const WorkoutExercisesPage({this.returnHome, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBarExercises(
        returnHome: returnHome,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ExerciseList(),
        ),
      ),
    );
  }
}

class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  late final ExerciseRepository exerciseRepo;
  List<Exercise> exercises = [];
  
  @override
  void initState() {
    super.initState();
    exerciseRepo = ExerciseRepository(ExerciseDataSource());
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    exercises = await exerciseRepo.fetchAllExercises();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '${exercises.length} Results',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).cardColor,
            ),
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ExerciseListItem(
                  exerciseName: exercise.name,
                  muscleGroup: 'N/A',
                  type: 'N/A',
                  imgPath: 'assets/images/exercise_placeholder.png',                  variations: 2, 
                  onTap: () {
                    
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final String exerciseName;
  final String muscleGroup;
  final String type;
  final String imgPath;
  final int variations;
  final VoidCallback? onTap;

  const ExerciseListItem({
    required this.exerciseName,
    required this.muscleGroup,
    required this.type,
    required this.imgPath,
    required this.variations,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              // Image.asset(
              //   imgPath,
              //   width: 60,
              //   height: 60,
              //   fit: BoxFit.cover,
              // ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Muscle Group: $muscleGroup'),
                    Text('Equipment: $type'),
                    Text('Variations: $variations'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}