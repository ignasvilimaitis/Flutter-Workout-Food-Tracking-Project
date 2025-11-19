import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'schemas/exercise_schema.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    log('Getting database instance');
    log('Current database: $_database');
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dir = await getDatabasesPath();
    final path = join(dir, fileName);
    log('Database path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<Database> _createDB(Database db, int version) async {
    await db.execute(ExerciseSchema.createExercisesTable);
    await db.execute(ExerciseSchema.createExerciseTypesTable);
    await db.execute(ExerciseSchema.createExerciseVariantsTable);
    await db.execute(ExerciseSchema.createMusclesTable);
    await db.execute(ExerciseSchema.createExerciseMusclesTable);

    return db;
  }
}