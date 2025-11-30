import 'workout_data_source.dart';
import 'workout_model.dart';

class ExerciseRepository {
  final ExerciseDataSource dataSource;

  ExerciseRepository(this.dataSource);

  Future<List<Exercise>> fetchAllExercises() async {
    return await dataSource.getAllExercises();
  }
}