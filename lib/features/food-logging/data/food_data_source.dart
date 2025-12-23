import 'package:flutter_application_1/core/local_time.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';

class FoodDataSource {
  LocalTime localTime = LocalTime();
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future<int> addFoodToDiaryEntry(int diaryEntryId, int foodItemId, {double? quantity}) async {
  final db = await _db;

  return await db.insert(
    'DiaryEntryFoodItem',
    {
      'fk_diary_entry_id': diaryEntryId,
      'fk_food_item_id': foodItemId,
      if (quantity != null) 'quantity': quantity,
    },
  );
}

Future<void> updateDiaryMacroTotals(
  String date,
  double calories,
  double proteins,
  double carbs,
  double fats,
) async {
  final db = await _db;

  await db.rawUpdate(
    '''
    UPDATE Diary
    SET
      total_calories_consumed = COALESCE(total_calories_consumed, 0) + ?,
      total_proteins_consumed = COALESCE(total_proteins_consumed, 0) + ?,
      total_carbs_consumed = COALESCE(total_carbs_consumed, 0) + ?,
      total_fats_consumed = COALESCE(total_fats_consumed, 0) + ?
    WHERE pk_date = ?
    ''',
    [calories, proteins, carbs, fats, date],
  );
}

Future<void> updateLastUsed(int foodItemId) async {
  final db = await _db;

  await db.update(
    'FoodItem',
    {
      'last_used': localTime.timeSinceEpoch(),
    },
    where: 'pk_fooditem_id = ?',
    whereArgs: [foodItemId],
  );
}

  Future<Map<String, dynamic>> getOrCreateDiaryEntryForSelectedDate(String currentDate,int categoryId) async {
  final db = await _db;

  String todayString = currentDate;
  // 1. Check if a DiaryEntry already exists for today
  final existing = await db.query(
    'DiaryEntry',
    where: 'fk_diary_date = ? AND fk_category_id = ?',
    whereArgs: [currentDate, categoryId],
    limit: 1,
  );

  if (existing.isNotEmpty) {
    return existing.first; // Found existing entry
  }

  // 3. Create new DiaryEntry for today
  final diaryEntryId = await db.insert(
    'DiaryEntry',
    {
      'fk_diary_date': todayString,
      'fk_category_id': categoryId,
      'macro_targets': null, // or whatever default you want
    },
  );

  // Fetch and return the newly created entry
  final newEntry = await db.query(
    'DiaryEntry',
    where: 'pk_diaryentry_id = ?',
    whereArgs: [diaryEntryId],
    limit: 1,
  );

  return newEntry.first;
}

Future<List<FoodItem>> getMostRecentFoods() async {
    final db = await _db;

    final result = await db.rawQuery('''
      SELECT *
      FROM FoodItem
      WHERE last_used > 0
      ORDER BY last_used DESC
      LIMIT 10;
    ''');

    return result.map((e) => FoodItem.fromMap(e)).toList();
  }


  Future<List<Map<String, dynamic>>> getFoodsForDiaryEntry(String date, int categoryId) async {
    final db = await _db;

    final result = await db.rawQuery('''
      SELECT fi.*, defi.quantity
      FROM FoodItem fi
      JOIN DiaryEntryFoodItem defi
        ON fi.pk_fooditem_id = defi.fk_food_item_id
      JOIN DiaryEntry de
        ON de.pk_diaryentry_id = defi.fk_diary_entry_id
      WHERE de.fk_diary_date = ?
        AND de.fk_category_id = ?;
    ''', [date, categoryId]);

    return result;
  }

  Future<Map<String, dynamic>?> getMacroTargets(String date) async {
  final db = await _db;

  final result = await db.query(
    'Diary',
    columns: [
      'calorie_target',
      'protein_percentage',
      'carb_percentage',
      'fat_percentage',
    ],
    where: 'pk_date = ?',
    whereArgs: [date],
    limit: 1,
  );

  if (result.isEmpty) return null;
  return result.first;
}


  Future<Map<String, dynamic>?> returnMacroTotals(String date) async {
    final db = await _db;

    final result = await db.rawQuery('''
      SELECT total_calories_consumed, total_proteins_consumed, total_carbs_consumed, total_fats_consumed
      FROM Diary
      WHERE pk_date = ?;
    ''', [date]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Food search by name or brand
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

  void createCurrentDay(String date) async {
    final db = await _db;
    await db.rawInsert(
      '''
      INSERT OR IGNORE INTO Diary (pk_date, calorie_target, protein_percentage, carb_percentage, fat_percentage, total_calories_consumed, total_proteins_consumed, total_carbs_consumed, total_fats_consumed)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
      [date, 2000, 20, 30, 50, 0.0001, 0.0001, 0.0001, 0.0001],
    );
  }
  // Returns diary targets for the current day
  Future<Map<String, dynamic>?> getCurrentDay(String date) async {
    final db = await _db;
    final List<Map<String, dynamic>> resp = await db.rawQuery(
      '''
      SELECT *
      FROM Diary
      WHERE pk_date = ?;
      ''',
      [date],
    );

    if (resp.isNotEmpty) {
      return resp.first;
    } else {
      createCurrentDay(date);
      return getCurrentDay(date);
      
    }
  }
}