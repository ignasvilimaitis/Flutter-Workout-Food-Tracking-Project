import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/food_data/list.dart';


class FoodSelector extends StatefulWidget {
  const FoodSelector({super.key});

  @override
  State<FoodSelector> createState() => _FoodSelectorState();
}

class _FoodSelectorState extends State<FoodSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: foods.map(
          (food) { 
          return FoodListTileWidget(
            food: food,
            isSelected: false,
            onSelectedFood: onSelectedFood,
          );
        }).toList(),
      ),
    );
  }

void onSelectedFood(FoodItem food) {
  Navigator.pop(context, food);
}

}

class FoodListTileWidget extends StatelessWidget {
  final FoodItem food;
  final bool isSelected;
  final ValueChanged<FoodItem> onSelectedFood;

  const FoodListTileWidget({super.key, required this.food, required this.isSelected, required this.onSelectedFood});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => onSelectedFood(food),
        title: Text(food.name),
        subtitle: Text(food.calories.toString()),
    );
  }
}




