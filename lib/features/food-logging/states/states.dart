import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';

// Per-diary entry that keeps its own foods and totals and notifies listeners
class DiaryEntry extends ChangeNotifier {
  final String id; // canonical id, e.g. 'breakfast'
  final List<FoodItem> foods = [];

  double calorieAmount = 0.0;
  double carbAmount = 0.0;
  double fatAmount = 0.0;
  double proteinAmount = 0.0;

  DiaryEntry({required this.id});

  void addFood(FoodItem food) {
    print("Adding food ${food.productName} to diary $id");
    foods.add(food);  // Add the food to the list
    calorieAmount += food.calories;
    carbAmount += food.carbs;
    fatAmount += food.fats;
    proteinAmount += food.proteins;
    print("New totals: calories=$calorieAmount, carbs=$carbAmount, fats=$fatAmount, proteins=$proteinAmount");
    _normalizeAndClamp();
    notifyListeners();
  }

  bool removeFood(FoodItem food) {
    if (!foods.remove(food)) return false;  // Remove the food from the list
    calorieAmount -= food.calories;
    carbAmount -= food.carbs;
    fatAmount -= food.fats;
    proteinAmount -= food.proteins;
    _normalizeAndClamp();
    notifyListeners();
    return true;
  }

  void _normalizeAndClamp() {
    const double eps = 1e-9;
    if (calorieAmount.abs() < eps) calorieAmount = 0.0;
    if (carbAmount.abs() < eps) carbAmount = 0.0;
    if (fatAmount.abs() < eps) fatAmount = 0.0;
    if (proteinAmount.abs() < eps) proteinAmount = 0.0;

    if (calorieAmount < 0) calorieAmount = 0.0;
    if (carbAmount < 0) carbAmount = 0.0;
    if (fatAmount < 0) fatAmount = 0.0;
    if (proteinAmount < 0) proteinAmount = 0.0;
  }

  Map<String, double> get totals => {
        'calories': calorieAmount,
        'carbs': carbAmount,
        'fats': fatAmount,
        'proteins': proteinAmount,
      };
}

// Container that holds multiple DiaryEntry instances.

class DiaryFoodList extends ChangeNotifier {
  final Map<String, DiaryEntry> _entries = {
    'breakfast': DiaryEntry(id: 'breakfast'),
    'lunch': DiaryEntry(id: 'lunch'),
    'dinner': DiaryEntry(id: 'dinner'),
    'snacks': DiaryEntry(id: 'snacks'),
  };

  DiaryEntry? entry(String diaryName) => _entries[(diaryName)];

  void add(FoodItem food, String diaryName) {
    final e = entry(diaryName.toLowerCase());
    if (e == null) throw ArgumentError('Invalid diaryName: $diaryName');
    notifyListeners();
    e.addFood(food);
  }

  void remove(FoodItem food, String diaryName) {
    final e = entry(diaryName.toLowerCase());
    if (e == null) throw ArgumentError('Invalid diaryName: $diaryName');
    e.removeFood(food);
    notifyListeners();
  }

  List<FoodItem> getFoods(String diaryName) {
    final e = entry(diaryName.toLowerCase());
    return e?.foods ?? <FoodItem>[];
  }

  double getCalorieAmount(String diaryName) {
    final e = entry(diaryName.toLowerCase());
    return e?.calorieAmount ?? 0.0;
  }

  double getCarbAmount(String diaryName) {
    final e = entry(diaryName.toLowerCase());
    return e?.carbAmount ?? 0.0;
  }

  double getFatAmount(String diaryName) {
    final e = entry(diaryName.toLowerCase());
    return e?.fatAmount ?? 0.0;
  } 

  double getProteinAmount(String diaryName) {
    final e = entry(diaryName.toLowerCase());
    return e?.proteinAmount ?? 0.0;
  }

  DiaryEntry? getEntry(String diaryName) => entry(diaryName);
}

class TotalMacros extends ChangeNotifier { // Tracks macros for the day
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

  // Fix tiny floating-point artifacts (e.g. -0.0) by snapping near-zero values to 0.0
  const double eps = 1e-9;
  if (calorieAmount.abs() < eps) calorieAmount = 0.0;
  if (carbAmount.abs() < eps) carbAmount = 0.0;
  if (fatAmount.abs() < eps) fatAmount = 0.0;
  if (proteinAmount.abs() < eps) proteinAmount = 0.0;
  // Ensures values do not go negative
  if (calorieAmount < 0) calorieAmount = 0.0;
  if (carbAmount < 0) carbAmount = 0.0;
  if (fatAmount < 0) fatAmount = 0.0;
  if (proteinAmount < 0) proteinAmount = 0.0;

  notifyListeners();
  }
}

class MacroGoal extends ChangeNotifier { // User's macro goals
   double carbGoal = 100;
   double fatGoal = 80;
   double proteinGoal = 100;
   double get calorieGoal => (carbGoal * 4) + (fatGoal * 8) + (proteinGoal * 4);

}