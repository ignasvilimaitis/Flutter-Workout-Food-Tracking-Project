import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/data/food_data_source.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';
import 'package:flutter_application_1/features/food-logging/data/food_repository.dart';
import 'package:flutter_application_1/features/food-logging/states/recent_foods.dart';
import 'package:flutter_application_1/features/food-logging/widgets/food_list_tile.dart';
import 'package:provider/provider.dart';

class FoodSelectorAll extends StatefulWidget {
  const FoodSelectorAll({super.key});

  @override
  State<FoodSelectorAll> createState() => _FoodSelectorAllState();
}

class _FoodSelectorAllState extends State<FoodSelectorAll> {

  FoodRepository foodRepository = FoodRepository(FoodDataSource());


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
                child: FutureBuilder<List<FoodItem>>(
      future: foodRepository.getRecentFoods(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final recentFoods = snapshot.data ?? [];

    return ListView.builder(
      shrinkWrap: true,
      itemCount: recentFoods.length,
      itemBuilder: (context, index) {
        final food = recentFoods[index];
        return FoodListTileWidget(
          food: food,
          isSelected: false,
          onSelectedFood: onSelectedFood,
        );
      },
    );
  },
)

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
