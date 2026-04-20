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
        e.created_at,
        e.updated_at,
        e.icon_path,
        e.is_custom,
        e.is_favourite,
        et.name AS type
      FROM Exercise e
      JOIN ExerciseTypes et ON e.fk_type_id = et.pk_type_id;
      '''
    );
    return resp.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<List<Variation>> getExerciseVariations(int exerciseId) async {
    final db = await _db;
    final List<Map<String, dynamic>> resp = await db.query(
      'ExerciseVariants',
      where: 'fk_exercise_id = ?',
      whereArgs: [exerciseId],
    );
    return resp.map((v) => Variation.fromMap(v)).toList();
  }

  Future<int> getExerciseVariationCount(int exerciseId) async {
    final db = await _db;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM ExerciseVariants WHERE fk_exercise_id = ?',
        [exerciseId],
      ),
    );
    return count ?? 0;
  }

  Future<List<MuscleGroup>> getExerciseMuscleGroup(int exerciseId) async {
    final db = await _db;
    final List<Map<String, dynamic>> resp = await db.rawQuery(
      '''
        SELECT 
          mg.name as 'group',
          m.name,
          em.role
        FROM ExerciseMuscle em
        JOIN Muscle m on em.fk_muscle_id = m.pk_muscle_id
        JOIN MuscleGroups mg on mg.pk_group_id = m.fk_group_id
        WHERE fk_exercise_id = ?
      ''',
      [exerciseId],
    );
    return resp.map((e) => MuscleGroup.fromMap(e)).toList();
  }

  // Get specific muscles worked in an exercise, categorized by the role. This is different to muscle groups which are broader categories.
  Future<Map<String, List>> getExerciseMuscles(int exerciseId) async {
    final db = await _db;

    final List<Map<String, dynamic>> resp = await db.rawQuery(
      '''
        SELECT 
          m.name,
          mg.name as "group",
          em.role
        FROM ExerciseMuscle em
        JOIN Muscle m on em.fk_muscle_id = m.pk_muscle_id
        JOIN MuscleGroups mg on mg.pk_group_id = m.fk_group_id
        WHERE fk_exercise_id = ?
      ''',
      [exerciseId],
    );

    final Map<String, List> musclesByRole = {};
    for (var row in resp) {
      final role = row['role'];
      final muscleName = "${row['group']} (${row['name']})";
      musclesByRole.putIfAbsent(role, () => []).add(muscleName);
    }

    return musclesByRole;
  }

  Future<int> toggleExerciseFavourite(int exerciseId) async {
    final db = await _db;

    // Toggle the is_favourite status based on current value
    final exercise = await db.query(
      'Exercise',
      columns: ['is_favourite'],
      where: 'pk_exercise_id = ?',
      whereArgs: [exerciseId],
    );
    final isFavourite = (exercise.isNotEmpty && exercise.first['is_favourite'] == 1);

    return await db.update(
      'Exercise',
      {'is_favourite': isFavourite ? 0 : 1},
      where: 'pk_exercise_id = ?',
      whereArgs: [exerciseId],
    );
  }
}