class ExerciseSchema {
  static const createExerciseTypesTable = '''
  CREATE TABLE ExerciseTypes (
    pk_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
  );
  ''';

  static const createExerciseTable = '''
  CREATE TABLE Exercise (
    pk_exercise_id INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_type_id INTEGER NOT NULL REFERENCES ExerciseTypes(pk_type_id),
    name TEXT NOT NULL,
    about TEXT,
    notes TEXT,
    created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
    updated_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
    icon_path TEXT,
    is_custom BOOLEAN NOT NULL DEFAULT 0,
    is_favourite BOOLEAN NOT NULL DEFAULT 0
  );
  ''';

  static const createExerciseVariantsTable = '''
  CREATE TABLE ExerciseVariants (
    pk_variant_id INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_exercise_id INTEGER NOT NULL REFERENCES Exercise(pk_exercise_id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT 0,
    about TEXT,
    notes TEXT,
    weight_unit TEXT,
    max_weight REAL,
    is_bilateral BOOLEAN NOT NULL DEFAULT 1
  );
  ''';

  static const createMuscleTable = '''
  CREATE TABLE Muscle (
    pk_muscle_id INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_group_id INTEGER REFERENCES MuscleGroups(pk_group_id),
    name TEXT NOT NULL
  );
  ''';

  static const createExerciseMuscleTable = '''
  CREATE TABLE ExerciseMuscle (
    fk_muscle_id INTEGER NOT NULL REFERENCES Muscle(pk_muscle_id) ON DELETE CASCADE,
    fk_exercise_id INTEGER NOT NULL REFERENCES Exercise(pk_exercise_id) ON DELETE CASCADE,
    role TEXT NOT NULL, -- 'primary', 'secondary', or 'tertiary'
    PRIMARY KEY (fk_exercise_id, fk_muscle_id, role)
  );
  ''';

  static const createMuscleGroupsTable = '''
  CREATE TABLE MuscleGroups (
    pk_group_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  );
  ''';
}

