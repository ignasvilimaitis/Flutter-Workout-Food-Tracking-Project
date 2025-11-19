class ExerciseSchema {
  static const createExerciseTypesTable = '''
  CREATE TABLE exercise_types (
    type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  );
  ''';

  static const createExercisesTable = '''
  CREATE TABLE exercises (
    exercise_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type_id INTEGER NOT NULL,
    about TEXT,
    notes TEXT,
    default_variant_id INTEGER
  );
  ''';

  static const createExerciseVariantsTable = '''
  CREATE TABLE exercise_variants (
    variant_id INTEGER PRIMARY KEY AUTOINCREMENT,
    exercise_id INTEGER NOT NULL,
    name TEXT,
    is_default INTEGER DEFAULT 0,
    about TEXT,
    notes TEXT
  );
  ''';

  static const createMusclesTable = '''
  CREATE TABLE muscles (
    muscle_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  );
  ''';

  static const createExerciseMusclesTable = '''
  CREATE TABLE exercise_muscles (
    exercise_id INTEGER NOT NULL,
    muscle_id INTEGER NOT NULL,
    role TEXT NOT NULL,
    PRIMARY KEY (exercise_id, muscle_id, role)
  );
  ''';
}
