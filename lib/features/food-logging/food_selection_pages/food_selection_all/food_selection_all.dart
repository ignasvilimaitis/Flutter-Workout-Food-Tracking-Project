import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/food_Item.dart';
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
          return Container(
                margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
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
