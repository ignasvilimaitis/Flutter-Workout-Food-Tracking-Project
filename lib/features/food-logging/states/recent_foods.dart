import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/food_Item.dart';

class RecentFoods extends ChangeNotifier {
  late List<FoodItem> recentFoods = [FoodItem(
    brand: 'Unknown',
    ingredientsText:  'Unknown',
    productName:  'Unknown',
    calories: 754,
    carbs: 100,
    fats: 50,
    proteins: 65,
    nutriments: null,
    servingSize: '100g'),
    FoodItem(
    brand: 'Unknown',
    ingredientsText:  'Unknown',
    productName:  'Unknown',
    calories: 74,
    carbs: 10,
    fats: 50,
    proteins: 5,
    nutriments: null,
    servingSize: '100g')];

  void addRecentFood(FoodItem food) {
    if (checkLength() == 10) {
      recentFoods[0] = food;
    }
    recentFoods.add(food);
    notifyListeners();
  }

  List<FoodItem> getRecentFoods() {
    return recentFoods;
  }

  int checkLength() {
    return recentFoods.length;
  }
}