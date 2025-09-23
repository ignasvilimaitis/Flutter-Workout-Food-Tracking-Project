import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/food_nutrition/food_nutrition_infopage.dart';

class FoodListTileWidget extends StatelessWidget {
  final FoodItem food;
  final bool isSelected;
  final ValueChanged<FoodItem> onSelectedFood;
  final bool ifRecent;

  const FoodListTileWidget({
    super.key,
    required this.ifRecent,
    required this.food,
    required this.isSelected,
    required this.onSelectedFood,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FoodNutritionInfopage(food: food)) ), // this should take you to the nutrition screen
      title: Text(food.productName),
      subtitle: Text("${food.calories.toStringAsFixed(1)}Kcal"
              "           ${food.proteins.toStringAsFixed(1)}P"
              "           ${food.carbs.toStringAsFixed(1)}C"
              "           ${food.fats.toStringAsFixed(1)}F"),
      // the fact this subtitle works is beyond me
      trailing: GestureDetector(
        onTap: () => onSelectedFood(food), // this will remain the same (essentially a quick add)
        child: Container(
          alignment: Alignment.center,
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Icon(Icons.add, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}