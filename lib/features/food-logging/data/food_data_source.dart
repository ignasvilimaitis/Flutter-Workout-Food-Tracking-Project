import 'package:flutter_application_1/features/food-logging/data/food_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';

class FoodDataSource {
  Future<Database> get _db async => await AppDatabase.instance.database;

  // All exercises from the database. Provides a "summary".
  Future<List<FoodItem>> getSearchedFoods(String searchedFood) async {
    final db = await _db;
    final List<Map<String, dynamic>> resp = await db.rawQuery(
      '''
      SELECT *
      FROM FoodItem
      WHERE name LIKE '%' || ? || '%'
      OR brand LIKE '%' || ? || '%';
      ''',
    [searchedFood, searchedFood],
    );

    return resp.map((e) => FoodItem.fromMap(e)).toList();
  }
}