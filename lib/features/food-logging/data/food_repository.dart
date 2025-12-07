import 'package:flutter_application_1/features/food-logging/data/food_data_source.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';


class FoodRepository {
  final FoodDataSource dataSource;

  FoodRepository(this.dataSource);

  Future<List<FoodItem>> getSearchedFoods(String input) async {
    return await dataSource.getSearchedFoods(input);
  }

  Future<Map<String, dynamic>> getOrCreateDiaryEntryForSelectedDate(String currentDate,int categoryId) async {
    return await dataSource.getOrCreateDiaryEntryForSelectedDate(currentDate,categoryId);
  }
  
  Future<List<Map<String, dynamic>>> getFoodsForDiaryEntry(String date, int categoryId) async {
    return await dataSource.getFoodsForDiaryEntry(date, categoryId);
  }

  Future<int> addFoodToDiaryEntry(int diaryEntryId, int foodItemId, {double? quantity}) async {
    return await dataSource.addFoodToDiaryEntry(diaryEntryId, foodItemId, quantity: quantity);
  }

  Future<Map<String, dynamic>?> getCurrentDay(String date) async {
    return await dataSource.getCurrentDay(date);
  }
}