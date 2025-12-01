import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';

class RecentFoods extends ChangeNotifier {
  late List<FoodItem> recentFoods = [];

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