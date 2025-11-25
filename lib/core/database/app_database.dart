import 'dart:developer';

import 'package:flutter_application_1/core/database/schemas/food_schema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'schemas/exercise_schema.dart';
import 'schemas/workout_schema.dart';
import '../utils/helpers.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  static const bool forceRecreateDB = false; // Set to true to delete existing DB on startup.

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getDatabasesPath();
    final path = join(dir, fileName);

    if (forceRecreateDB) {
      log('forceRecreateDb is true — deleting existing database (if any)');
      try {
        await deleteDatabase(path);
        log('Deleted existing database at $path');
      } catch (e, st) {
        log('Failed to delete database: $e\n$st');
      }
    }

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  Future<Database> _createDB(Database db, int version) async {
    // Order of table creation matters due to foreign key constraints

    // Exercise-related tables
    await db.execute(ExerciseSchema.createMuscleGroupsTable);
    await db.execute(ExerciseSchema.createExerciseTypesTable);
    await db.execute(ExerciseSchema.createMuscleTable);
    await db.execute(ExerciseSchema.createExerciseTable);
    await db.execute(ExerciseSchema.createExerciseVariantsTable);
    await db.execute(ExerciseSchema.createExerciseMuscleTable);

    // Workout-related tables
    await db.execute(WorkoutSchema.createWorkoutTable);
    await db.execute(WorkoutSchema.createWorkoutEntriesTable);
    await db.execute(WorkoutSchema.createSetsTable);

    // Food-related tables
    await db.execute(FoodSchema.createFoodItemTable);
    await db.execute(FoodSchema.createCategoryTable);
    await db.execute(FoodSchema.createMealTable);
    await db.execute(FoodSchema.createDiaryEntryTable);
    await db.execute(FoodSchema.createDiaryEntryFoodItemTable);
    await db.execute(FoodSchema.createMealFoodItemTable);

    //Populate default values
    await _populateDefaultValues(db);

    return db;
  }

  static _populateDefaultValues(Database db) async {
    // Load default data from JSON files
    final defaultMusclesJson = await readJson('assets/data/default_muscles.json');
    final defaultExercisesJson = await readJson('assets/data/default_exercises.json');
    final defaultFoodJson = await readJson('assets/data/default_foods.json');


    final defaultData = [
      defaultMusclesJson,
      defaultExercisesJson,
      defaultFoodJson,
    ];

    // Dynamically insert data into respective tables
    for (final dataSet in defaultData) {
      for (final schema in dataSet.keys) {
        final values = dataSet[schema];
        for (final item in values) {
          await db.insert(schema, item);
        }
      }
    }
  }
}