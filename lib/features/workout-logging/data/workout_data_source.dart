import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import 'workout_model.dart';

class ExerciseDataSource {
  Future<Database> get _db async => await AppDatabase.instance.database;

  // All exercises from the database. Provides a "summary".
  Future<List<Exercise>> getAllExercises() async {
    final db = await _db;
    final List<Map<String, dynamic>> resp = await db.rawQuery(
      '''
      SELECT 
        e.pk_exercise_id, 
        e.fk_type_id, 
        e.name,
        e.about,
        e.notes,
        e.created_at,
        e.updated_at,
        e.icon_path,
        e.is_custom,
        et.name AS type
      FROM Exercise e
      JOIN ExerciseTypes et ON e.fk_type_id = et.pk_type_id;
      '''
    );
    return resp.map((e) => Exercise.fromMap(e)).toList();
  }
}