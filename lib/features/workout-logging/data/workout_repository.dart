import 'workout_data_source.dart';
import 'workout_model.dart';

class ExerciseRepository {
  final ExerciseDataSource dataSource;

  ExerciseRepository(this.dataSource);

  // Getters
  Future<List<Exercise>> fetchAllExercises() async {
    return await dataSource.getAllExercises();
  }

  Future<List<Exercise>> fetchExercise(int exerciseId) async {
    final allExercises = await fetchAllExercises();
    return allExercises.where((e) => e.id == exerciseId).toList();
  }

  Future<List<Variation>> fetchExerciseVariations(int exerciseId) async {
    return await dataSource.getExerciseVariations(exerciseId);
  }

  Future<int> fetchExerciseVariationCount(int exerciseId) async {
    return await dataSource.getExerciseVariationCount(exerciseId);
  }

  Future<List<MuscleGroup>> fetchExerciseMuscleGroup(int exerciseId) async {
    return await dataSource.getExerciseMuscleGroup(exerciseId);
  }

  Future<Map<String, List>> fetchExerciseMuscles(int exerciseId) async {
    return await dataSource.getExerciseMuscles(exerciseId);
  }

  // Setters
  Future<int> toggleFavouriteExercise(int exerciseId) async {
    return await dataSource.toggleExerciseFavourite(exerciseId);
  }


  // Misc
  Future<String> getPrimaryMuscleGroup(int exerciseId) async {
    final List<MuscleGroup> muscleGroup = (await fetchExerciseMuscleGroup(exerciseId));
    for (var mg in muscleGroup) {
      if (mg.role == 'Primary') {
        return mg.group;
      }
    }
    return 'N/A';
  }
}