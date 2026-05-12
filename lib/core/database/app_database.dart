import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_application_1/core/database/schemas/food_schema.dart' show FoodSchema;
import 'schemas/exercise_schema.dart' show ExerciseSchema, ExerciseTriggers;
import 'schemas/workout_schema.dart' show WorkoutSchema;
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
    // Exercise-related tables
    for (final statement in ExerciseSchema.all) {await db.execute(statement);}
    for (final statement in ExerciseTriggers.all) {await db.execute(statement);}

    // Workout-related tables
    for (final statement in WorkoutSchema.all) {await db.execute(statement);}

    // Food-related tables
    for (final statement in FoodSchema.all) {await db.execute(statement);}

    //Populate default values
    await importUsdaFoodsFromAsset('assets/data/usda_foundation_foods.json', db);
    await _populateDefaultValues(db);

    return db;
  }

  static Future _populateDefaultValues(Database db) async {
    // Load default data from JSON files
    final defaultMusclesJson = await readJson('assets/data/default_muscles.json');
    final defaultExercisesJson = await readJson('assets/data/default_exercises.json');


    final defaultData = [
      defaultMusclesJson,
      defaultExercisesJson,
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
    log('Default values populated successfully.');
  }

}