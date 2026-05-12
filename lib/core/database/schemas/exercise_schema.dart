class ExerciseSchema {
  static const createExerciseTypeTable = '''
  CREATE TABLE ExerciseType (
    pk_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
  );
  ''';

  static const createExerciseTable = '''
  CREATE TABLE Exercise (
    pk_exercise_id INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_type_id INTEGER NOT NULL REFERENCES ExerciseType(pk_type_id),
    name TEXT NOT NULL,
    about TEXT,
    created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
    updated_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
    last_used_at INTEGER,
    icon_path TEXT,
    is_custom BOOLEAN NOT NULL DEFAULT 0,
    is_favourite BOOLEAN NOT NULL DEFAULT 0,
    deleted_at INTEGER DEFAULT NULL
  );
  ''';

  static const createExerciseVariantTable = '''
  CREATE TABLE ExerciseVariant (
    pk_variant_id INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_exercise_id INTEGER NOT NULL REFERENCES Exercise(pk_exercise_id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT 0,
    about TEXT,
    notes TEXT,
    weight_unit TEXT,
    max_weight REAL,
    is_bilateral BOOLEAN NOT NULL DEFAULT 1,
    created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
    updated_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
    deleted_at INTEGER DEFAULT NULL
  );
  ''';

  static const createMuscleTable = '''
  CREATE TABLE Muscle (
    pk_muscle_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    svg_id TEXT
  );
  ''';

  static const createMuscleRoleTable = '''
  CREATE TABLE MuscleRole (
    pk_role_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL, -- 'primary', 'secondary', 'tertiary', or custom role name
    sequence INTEGER NOT NULL, -- for ordering in the UI
    factor REAL NOT NULL -- relative factor (e.g., 1.0 for primary, 0.5 for secondary)
  );
  ''';

  static const createExerciseMuscleTable = '''
  CREATE TABLE ExerciseMuscle (
    fk_muscle_id INTEGER NOT NULL REFERENCES Muscle(pk_muscle_id) ON DELETE CASCADE,
    fk_variant_id INTEGER NOT NULL REFERENCES ExerciseVariant(pk_variant_id) ON DELETE CASCADE,
    fk_role_id INTEGER NOT NULL REFERENCES MuscleRole(pk_role_id),
    UNIQUE (fk_variant_id, fk_muscle_id),
    PRIMARY KEY(fk_muscle_id, fk_variant_id, fk_role_id)
  );
  ''';

  static const createMuscleGroupTable = '''
  CREATE TABLE MuscleGroup (
    pk_group_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
    updated_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
    deleted_at INTEGER DEFAULT NULL
  );
  ''';

  static const createMuscleGroupMembership = '''
  CREATE TABLE MuscleGroupMembership (
    fk_group_id INTEGER NOT NULL REFERENCES MuscleGroup(pk_group_id),
    fk_muscle_id INTEGER NOT NULL REFERENCES Muscle(pk_muscle_id),
    PRIMARY KEY(fk_group_id, fk_muscle_id)
  );
  ''';

  // LIST FOR AWAITS - !IMPORTANT - Keep in mind order!
  static const List<String> all = [
    createMuscleGroupTable,
    createExerciseTypeTable,
    createMuscleRoleTable,
    createMuscleTable,
    createExerciseTable,
    createExerciseVariantTable,
    createExerciseMuscleTable,
    createMuscleGroupMembership
  ];
}

// ======================================================= TRIGGERS FOR EXERCISE TABLES =======================================================

class ExerciseTriggers {
  static const cascadeSoftDeleteExerciseVariants = '''
  CREATE TRIGGER IF NOT EXISTS trg_exercise_soft_delete_cascade
  AFTER UPDATE OF deleted_at ON Exercise
  FOR EACH ROW
  WHEN NEW.deleted_at IS NOT NULL AND OLD.deleted_at IS NULL
  BEGIN
    UPDATE ExerciseVariant
      SET deleted_at = NEW.deleted_at,
        updated_at = CAST(strftime('%s', 'now') AS INTEGER)
      WHERE fk_exercise_id = NEW.pk_exercise_id
        AND deleted_at IS NULL;
  END;
  ''';

  static const cascadeRestoreExerciseVariants = '''
  CREATE TRIGGER IF NOT EXISTS trg_exercise_restore_cascade
  AFTER UPDATE OF deleted_at ON Exercise
  FOR EACH ROW
  WHEN NEW.deleted_at is NULL AND OLD.deleted_at IS NOT NULL
  BEGIN
    UPDATE ExerciseVariant
      SET deleted_at = NULL,
        updated_at = CAST(strftime('%s', 'now') AS INTEGER)
      WHERE fk_exercise_id = NEW.pk_exercise_id
        AND deleted_at = OLD.deleted_at;
  END;
  ''';

    static const touchExerciseUpdatedAt = '''
  CREATE TRIGGER IF NOT EXISTS trg_exercise_touch_updated_at
  AFTER UPDATE ON Exercise
  FOR EACH ROW
  WHEN NEW.updated_at = OLD.updated_at
  BEGIN
    UPDATE Exercise
       SET updated_at = CAST(strftime('%s', 'now') AS INTEGER)
     WHERE pk_exercise_id = NEW.pk_exercise_id;
  END;
  ''';
 
  static const touchExerciseVariantUpdatedAt = '''
  CREATE TRIGGER IF NOT EXISTS trg_variant_touch_updated_at
  AFTER UPDATE ON ExerciseVariant
  FOR EACH ROW
  WHEN NEW.updated_at = OLD.updated_at
  BEGIN
    UPDATE ExerciseVariant
       SET updated_at = CAST(strftime('%s', 'now') AS INTEGER)
     WHERE pk_variant_id = NEW.pk_variant_id;
  END;
  ''';
 
  static const touchMuscleGroupUpdatedAt = '''
  CREATE TRIGGER IF NOT EXISTS trg_musclegroup_touch_updated_at
  AFTER UPDATE ON MuscleGroup
  FOR EACH ROW
  WHEN NEW.updated_at = OLD.updated_at
  BEGIN
    UPDATE MuscleGroup
       SET updated_at = CAST(strftime('%s', 'now') AS INTEGER)
     WHERE pk_group_id = NEW.pk_group_id;
  END;
  ''';

  // LIST FOR AWAITS
  static const List<String> all = [
    cascadeSoftDeleteExerciseVariants,
    cascadeRestoreExerciseVariants,
    touchExerciseUpdatedAt,
    touchExerciseVariantUpdatedAt,
    touchMuscleGroupUpdatedAt
  ];
}