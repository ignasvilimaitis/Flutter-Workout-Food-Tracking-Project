import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/food_item.dart';
import 'package:flutter_application_1/features/food-logging/openfoodfacts_queries/get_query.dart';
import 'package:flutter_application_1/features/food-logging/states/recent_foods.dart';
import 'package:flutter_application_1/features/food-logging/widgets/food_list_tile.dart';
import 'package:provider/provider.dart';

class FoodSelectorAll extends StatefulWidget {
  const FoodSelectorAll({super.key});

  @override
  State<FoodSelectorAll> createState() => _FoodSelectorAllState();
}

class _FoodSelectorAllState extends State<FoodSelectorAll> {

  final RecentFoods recentFoods = RecentFoods();


  @override
  Widget build(BuildContext context) {
    return Consumer<RecentFoods>(
      builder: (context, recentFoodList, child) {
          return UnconstrainedBox(
            alignment: Alignment.topCenter,
            child: Container(
              width: 390,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: recentFoodList.getRecentFoods().length,
                itemBuilder: (context, index) {
                  final recentFoods = recentFoodList.getRecentFoods();
                  final food = recentFoods[index];
                  print(recentFoodList.getRecentFoods());
                  return Column(
                    children: [
                      FoodListTileWidget(
                        food: food,
                        isSelected: false,
                        onSelectedFood: onSelectedFood,
                      ),
                    ],
                  );
                },
                      ),
            ),
          );
      } 
    );
  }
    void onSelectedFood(FoodItem food) {
    Provider.of<RecentFoods>(context, listen: false).addRecentFood(food);
    //foods.clear();
    Navigator.pop(context, food);
  }
}
