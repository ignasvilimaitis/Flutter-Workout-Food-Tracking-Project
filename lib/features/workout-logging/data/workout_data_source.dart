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
      JOIN ExerciseType et ON e.fk_type_id = et.pk_type_id;
      '''
    );
    return resp.map((e) => Exercise.fromMap(e)).toList();
  }

  Future<List<Variation>> getExerciseVariations(int exerciseId) async {
    final db = await _db;
    final List<Map<String, dynamic>> resp = await db.query(
      'ExerciseVariant',
      where: 'fk_exercise_id = ?',
      whereArgs: [exerciseId],
    );
    return resp.map((v) => Variation.fromMap(v)).toList();
  }

  Future<int> getExerciseVariationCount(int exerciseId) async {
    final db = await _db;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM ExerciseVariant WHERE fk_exercise_id = ?',
        [exerciseId],
      ),
    );
    return count ?? 0;
  }

  /// Gets an exercises default variant muscle groups - used in the UI to quickly summarise what GROUPs that exercise mainly targets.
  Future<List<MuscleGroup>> getDefaultVariantMuscleGroup(int exerciseId) async {
    final db = await _db;
    final List<Map<String, dynamic>> resp = await db.rawQuery(
      '''
        -- Get the default variant by exerciseId
        WITH DefaultVariant AS (
          SELECT pk_variant_id
          FROM ExerciseVariant
          WHERE is_default = 1
          AND deleted_at IS NULL 
          AND fk_exercise_id = ?
        )

        SELECT 
          mg.name as "group",
          m.name,
          mr.name as "role"
        FROM ExerciseMuscle em
        JOIN Muscle m on em.fk_muscle_id = m.pk_muscle_id
        JOIN MuscleGroupMembership mgm on mgm.fk_muscle_id = m.pk_muscle_id
        JOIN MuscleGroup mg on mg.pk_group_id = mgm.fk_group_id
        JOIN MuscleRole mr on mr.pk_role_id = em.fk_role_id
        JOIN DefaultVariant dv on em.fk_variant_id = dv.pk_variant_id;
      ''',
      [exerciseId],
    );
    return resp.map((e) => MuscleGroup.fromMap(e)).toList();
  }

  /// Get specific muscles worked in an exercise categorised by the variant. This is different to muscle groups which are broader categories.
  Future<Map<int, Map<String, List<VariantMuscle>>>> getExerciseMuscles(int exerciseId) async {
    final db = await _db;

    final List<Map<String, dynamic>> resp = await db.rawQuery(
      '''
        WITH Variants AS (
          SELECT pk_variant_id
          FROM ExerciseVariant
          WHERE deleted_at IS NULL 
          AND fk_exercise_id = ?
        )

        SELECT
          em.fk_variant_id,
          m.pk_muscle_id,
          m.name,
          mg.name as "group",
          mr.name as "role",
          mr.color,
          m.svg_id,
          mr.sequence as "role_sequence",
          mr.factor as "role_factor"
        FROM ExerciseMuscle em
        JOIN Muscle m on em.fk_muscle_id = m.pk_muscle_id
        JOIN MuscleGroupMembership mgm on mgm.fk_muscle_id = m.pk_muscle_id
        JOIN MuscleGroup mg on mg.pk_group_id = mgm.fk_group_id
        JOIN MuscleRole mr on mr.pk_role_id = em.fk_role_id
        JOIN Variants v on v.pk_variant_id = em.fk_variant_id

        ORDER BY mr.sequence ASC
      ''',
      [exerciseId],
    );
    
    final List<VariantMuscle> exerciseMuscles = resp.map((e) => VariantMuscle.fromMap(e)).toList();
    final Map<int, Map<String, List<VariantMuscle>>> musclesByRole = {};
    for (var muscle in exerciseMuscles) {
      final int variantId = muscle.variantId;
      final String role = muscle.role;
      musclesByRole
        .putIfAbsent(variantId, () => {})
        .putIfAbsent(role, () => [])
        .add(muscle);
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