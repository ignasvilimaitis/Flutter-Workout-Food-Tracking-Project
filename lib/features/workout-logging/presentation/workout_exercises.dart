import 'package:flutter/material.dart';

// Widgets
import 'workout_base.dart' show CustomAppBarExercises;
import 'widgets/exercises/exercise_list.dart';
// Data
import '../data/workout_repository.dart';
import '../data/workout_model.dart' show Exercise;
import '../data/workout_data_source.dart' show ExerciseDataSource;

class WorkoutExercisesPage extends StatefulWidget {
  final VoidCallback? returnHome;

  const WorkoutExercisesPage({this.returnHome, super.key});

  @override
  State<WorkoutExercisesPage> createState() => _WorkoutExercisesPageState();
}

class _WorkoutExercisesPageState extends State<WorkoutExercisesPage> {
  late final ExerciseRepository exerciseRepo;

  final TextEditingController searchController = TextEditingController();
  List<Exercise> exercises = [];
  List<Exercise> filteredExercises = [];
  Map<int, int> variationsCount = {};
  Map<int, String> primaryMuscleGroups = {};

  @override
  void initState() {
    super.initState();
    exerciseRepo = ExerciseRepository(ExerciseDataSource());
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    exercises = await exerciseRepo.fetchAllExercises();
    for (var exercise in exercises) {
      final count = await exerciseRepo.fetchExerciseVariationCount(exercise.id);
      final muscleGroup = await exerciseRepo.getPrimaryMuscleGroup(exercise.id);

      variationsCount[exercise.id] = count;
      primaryMuscleGroups[exercise.id] = muscleGroup;
    }

    filteredExercises = List.from(exercises); // Initialize filtered list
    setState(() {});
  }

  void _filterExercises(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredExercises = List.from(exercises); // Reset to all exercises
      } else {
        filteredExercises = exercises.where((exercise) {
          return exercise.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _toggleFavourite(int exerciseId) {
    setState(() {
      final exercise = exercises.firstWhere((ex) => ex.id == exerciseId);
      exercise.isFavourite = !exercise.isFavourite;
    });
    exerciseRepo.toggleFavouriteExercise(exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBarExercises(
          returnHome: widget.returnHome,
          searchController: searchController,
          onSearchChanged: _filterExercises, // Pass the search callback
        ),
        body: TabBarView(
          children: [
            // All 
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ExerciseList(
                  exercises: filteredExercises, // Pass the filtered list
                  variationsCount: variationsCount,
                  primaryMuscleGroups: primaryMuscleGroups,
                  onFavouriteChanged: (exerciseId) => _toggleFavourite(exerciseId),
                ),
              ),
            ),

            // Favourites
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ExerciseList(
                  exercises: filteredExercises.where((exercise) => exercise.isFavourite).toList(), // Pass the filtered list
                  variationsCount: variationsCount,
                  primaryMuscleGroups: primaryMuscleGroups,
                  onFavouriteChanged: (exerciseId) => _toggleFavourite(exerciseId),
                ),
              ),
            ),

            // Custom
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ExerciseList(
                  exercises: filteredExercises.where((exercise) => exercise.isCustom).toList(), // Pass the filtered list
                  variationsCount: variationsCount,
                  primaryMuscleGroups: primaryMuscleGroups,
                  onFavouriteChanged: (exerciseId) => _toggleFavourite(exerciseId),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}