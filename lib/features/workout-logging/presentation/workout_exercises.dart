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
  late final Future<Map<String, dynamic>> _exerciseFuture;
  List<Exercise> exercises = [];
  List<Exercise> filteredExercises = [];

  Map<int, int> variationsCount = {};
  Map<int, String> primaryMuscleGroups = {};

  @override
  void initState() {
    super.initState();
    exerciseRepo = ExerciseRepository(ExerciseDataSource());
    _exerciseFuture = _loadExercises();
  }

  Future<Map<String, dynamic>> _loadExercises() async {
    exercises = await exerciseRepo.fetchAllExercises();
    for (var exercise in exercises) {
      final count = await exerciseRepo.fetchExerciseVariationCount(exercise.id);
      final muscleGroup = await exerciseRepo.getPrimaryMuscleGroup(exercise.id);

      variationsCount[exercise.id] = count;
      primaryMuscleGroups[exercise.id] = muscleGroup;
    }

    filteredExercises = List.from(exercises); // Initialize filtered list
    
    return {
      'variationsCount': variationsCount,
      'primaryMuscleGroups': primaryMuscleGroups,
    };
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
    final exercise = exercises.firstWhere((ex) => ex.id == exerciseId);
    exercise.isFavourite = !exercise.isFavourite;
    exerciseRepo.toggleFavouriteExercise(exerciseId);
    setState(() {});
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
        body: FutureBuilder<Map<String, dynamic>>(
          future: _exerciseFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading exercises'));
            }
            if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            }

            final data = snapshot.data!;
            final variationsCount = data['variationsCount'] as Map<int, int>;
            final primaryMuscleGroups = data['primaryMuscleGroups'] as Map<int, String>;

            return TabBarView(
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
                    exercises: filteredExercises.where((exercise) => exercise.isFavourite).toList(),
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
                    exercises: filteredExercises.where((exercise) => exercise.isCustom).toList(),
                    variationsCount: variationsCount,
                    primaryMuscleGroups: primaryMuscleGroups,
                    onFavouriteChanged: (exerciseId) => _toggleFavourite(exerciseId),
                  ),
                ),
              ),
            ],
          );
          }
        ),
      ),
    );
  }
}