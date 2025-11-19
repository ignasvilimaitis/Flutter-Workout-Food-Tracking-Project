class WorkoutSchema {
  static const createWorkoutsTable = '''
  CREATE TABLE workouts (
    workout_id INTEGER PRIMARY KEY AUTOINCREMENT,
    started_at INTEGER,
    finished_at INTEGER,
    notes TEXT
  );
  ''';

  static const createWorkoutEntriesTable = '''
  CREATE TABLE workout_entries (
    entry_id INTEGER PRIMARY KEY AUTOINCREMENT,
    workout_id INTEGER NOT NULL,
    exercise_id INTEGER NOT NULL,
    variant_id INTEGER,
    order_index INTEGER
  );
  ''';

  static const createSetsTable = '''
  CREATE TABLE sets (
    set_id INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id INTEGER NOT NULL,
    reps INTEGER,
    weight_value REAL,
    weight_unit TEXT,
    timestamp INTEGER
  );
  ''';
}
