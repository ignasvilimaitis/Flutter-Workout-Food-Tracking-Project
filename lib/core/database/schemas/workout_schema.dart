class WorkoutSchema {
  static const createWorkoutTable = '''
  CREATE TABLE Workout (
    pk_workout_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    notes TEXT,

    -- Use UNIX timestamps - better for performance
    started_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
    finished_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s', 'now') AS INTEGER)),
  );
  '''; 

  static const createWorkoutEntriesTable = '''
  CREATE TABLE WorkoutEntries (
    pk_entry_id INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_workout_id INTEGER NOT NULL REFERENCES Workout(pk_workout_id) ON DELETE CASCADE, -- Foreign key to Workouts table
    fk_variant_id INTEGER NOT NULL REFERENCES ExerciseVariants(pk_variant_id), -- Foreign key to Exercise Variants table
    order_index INTEGER,
    notes TEXT
  );
  ''';

  static const createSetsTable = '''
  CREATE TABLE Sets (
    pk_set_id INTEGER PRIMARY KEY AUTOINCREMENT,
    fk_entry_id INTEGER NOT NULL REFERENCES WorkoutEntries(pk_entry_id) ON DELETE CASCADE, -- Foreign key to Workout Entries table
    reps INTEGER,
    weight_value REAL,
    weight_unit TEXT,
    rpe INTEGER,
    is_failure BOOLEAN,
    is_dropset BOOLEAN,
    is_warmup BOOLEAN,
    is_left BOOLEAN,
    is_right BOOLEAN,
    timestamp INTEGER
  );
  ''';
}
