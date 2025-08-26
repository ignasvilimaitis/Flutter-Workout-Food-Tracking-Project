
import 'package:flutter/material.dart';

List<FoodItem> foods = [
  FoodItem(name: 'Mango', calories: 120, carbs: 28.0, fats: 0.5, proteins: 1.0),
  FoodItem(name: 'Apple', calories: 105, carbs: 27.0, fats: 0.3, proteins: 0.5),
  FoodItem(name: 'Orange', calories: 75, carbs: 18.0, fats: 0.2, proteins: 1.5),
  FoodItem(name: 'Banana', calories: 89, carbs: 22.8, fats: 0.3, proteins: 1.1),
];

class FoodItem {
  final String name;
  final double calories;
  final double carbs;
  final double fats;
  final double proteins;

  FoodItem({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fats,
    required this.proteins
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItem &&
          runtimeType == other.runtimeType &&
          name == other.name && calories == other.calories &&
          carbs == other.carbs && fats == other.fats &&
           proteins == other.proteins;

  @override
  int get hashCode => name.hashCode ^ calories.hashCode;
}

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




