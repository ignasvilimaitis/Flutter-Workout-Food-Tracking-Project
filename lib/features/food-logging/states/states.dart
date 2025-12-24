import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums.dart';
import 'package:flutter_application_1/core/local_time.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';
import 'package:flutter_application_1/features/food-logging/data/food_repository.dart';

// Per-diary entry that keeps its own foods and totals and notifies listeners
class DiaryEntry extends ChangeNotifier {
  
}

// Container that holds multiple DiaryEntry instances.

class DiaryFoodList extends ChangeNotifier {
  
}



class MacroGoal extends ChangeNotifier { // User's macro goals
   double carbGoal = 100;
   double fatGoal = 80;
   double proteinGoal = 100;
   double saltGoal = 10;
   double get calorieGoal => (carbGoal * 4) + (fatGoal * 8) + (proteinGoal * 4);

}

class FoodViewModel extends ChangeNotifier {
  final FoodRepository repo;

  FoodViewModel(this.repo);


  String _selectedDate = LocalTime().currentDate;
  Map<int, List<FoodItem>> _foodsByDiary = {};
  Map<String, double> _macroTotals = {};
  Map<String, double> _macroTargets = {};


  Map<String, double> get macroTotals => _macroTotals;
  String get selectedDate => _selectedDate;
  Map<String, double> get macroTargets => _macroTargets;


  Future<void> changeDate(String date) async {
    _selectedDate = date;
    await repo.getCurrentDay(date);
    await _loadAll();
  }

Future<void> loadForDate(String date) async {
  _selectedDate = date;

  await repo.getCurrentDay(date);

  _macroTotals = await repo.getMacroTotals(date);
  _macroTargets = await repo.getMacroTargets(date);

  notifyListeners();
}


  Future<void> _loadAll() async {
    _macroTotals = await repo.getMacroTotals(_selectedDate);
    _macroTargets = await repo.getMacroTargets(_selectedDate);

    for (final id in [1, 2, 3, 4]) {
      final foods = await repo.getFoodsForDiaryEntry(_selectedDate, id);
      _foodsByDiary[id] =
          foods.map(FoodItem.fromMap).toList();
    }

    notifyListeners();
  }
  
List<FoodItem> foodsForDiary(int diaryId) {
  return _foodsByDiary[diaryId] ?? [];
}

  Future<void> addFood(
    int diaryId,
    FoodItem food,
  ) async {
    final entry = await repo.getOrCreateDiaryEntryForSelectedDate(
      _selectedDate,
      diaryId,
    );

    await repo.addFoodToDiaryEntry(entry['pk_diaryentry_id'], food.id, 1 );
    await repo.updateDiaryMacroTotals(
      _selectedDate,
      food.calories,
      food.proteins,
      food.carbs,
      food.fats,
    );

    await repo.updateLastUsed(food.id);

    await _loadAll();
  }

  
}


class CurrentMacroDisplay extends ChangeNotifier {
  MacroType currentDisplay = MacroType.protein;

  void setCurrentDisplay(MacroType type) {
    currentDisplay = type;
    notifyListeners();
  }

  MacroType getCurrentDisplay() => currentDisplay;


}
