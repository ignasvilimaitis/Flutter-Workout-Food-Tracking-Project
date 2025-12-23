import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';

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

class CurrentMacroDisplay extends ChangeNotifier {
  MacroType currentDisplay = MacroType.protein;

  void setCurrentDisplay(MacroType type) {
    currentDisplay = type;
    notifyListeners();
  }

  MacroType getCurrentDisplay() => currentDisplay;


}
