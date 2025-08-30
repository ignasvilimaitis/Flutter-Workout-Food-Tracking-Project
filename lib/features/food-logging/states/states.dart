import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';

class FoodModel extends ChangeNotifier {
  final List<FoodItem> _foods = [];

  List<FoodItem> get foods => _foods;

  void add(FoodItem food) {
    _foods.add(food);
    notifyListeners();
  

  }
  void remove(FoodItem food) {
    _foods.remove(food);
    notifyListeners();
  }
}

class MacroModel extends ChangeNotifier {
   double carbGoal = 100;
   double fatGoal = 80;
   double proteinGoal = 100;
   double get calorieGoal => (carbGoal * 4) + (fatGoal * 8) + (proteinGoal * 4);



  
}

class WidgetCalorieState extends ChangeNotifier {
  double calorieAmount = 0;
  double carbAmount = 0;
  double fatAmount = 0;
  double proteinAmount = 0;

  void addMacros(FoodItem food) {
    calorieAmount += food.calories;
    carbAmount += food.carbs;
    fatAmount += food.fats;
    proteinAmount += food.proteins;
    notifyListeners();

  }

  void removeMacros(FoodItem food) {
    calorieAmount -= food.calories;
    carbAmount -= food.carbs;
    fatAmount -= food.fats;
    proteinAmount -= food.proteins;
    notifyListeners();
  }
}