class ProfileSchema {

static const userProfileTable = '''
CREATE TABLE UserProfile (
    user_id        INTEGER PRIMARY KEY,
    name           TEXT,
    age            INTEGER,
    height_cm      REAL,
    weight_kg      REAL,
    gender         TEXT,
    activity_level TEXT,
    created_at     TEXT DEFAULT CURRENT_TIMESTAMP
    );
    ''';

  static const  foodSettingsTable = '''
CREATE TABLE FoodSettings (
    food_settings_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id             INTEGER NOT NULL UNIQUE,
    daily_calorie_target INTEGER,
    protein_percent     REAL,
    carb_percent        REAL,
    fat_percent         REAL,
    weight_goal         REAL,
    FOREIGN KEY (user_id) REFERENCES UserProfile(user_id)
);
''';


static const String workoutSettingsTable = '''
CREATE TABLE WorkoutSettings (
    workout_settings_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id             INTEGER NOT NULL UNIQUE,
    rest_timer          INTEGER,
    intensity_scaling   REAL,
    FOREIGN KEY (user_id) REFERENCES UserProfile(user_id)
);
''';
}

