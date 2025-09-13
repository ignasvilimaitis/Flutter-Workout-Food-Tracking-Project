import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/openfoodfacts_queries/get_query.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class FoodSelector extends StatefulWidget {
  const FoodSelector({super.key});

  @override
  State<FoodSelector> createState() => _FoodSelectorState();
}

class _FoodSelectorState extends State<FoodSelector> {
  final GetQuery query = GetQuery();
  List<FoodItem> foods = []; // <--- state field (was a local var before)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((16.0)),
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
          width: 260,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((16.0)),
            color: Colors.white,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search foods',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide.none
              ),
            ),
            onSubmitted: (String value) async {
              print('Searching for: $value');
              SearchResult? result = await query.searchProducts(value);
              List<Product>? products = result?.products;

              setState(() {
                foods =
                    products?.map((product) {
                      final nutr = product.nutriments;

                      // helper to read most nutrients per 100g
                      double _get(Nutrient n) =>
                          nutr?.getValue(n, PerSize.oneHundredGrams) ?? 0.0;
                      // Gotta use helper methods for all the macros since they removed direct getters, e.g. product.carbohydrates
                      // Now you have to read through enum values

                      // Calories: prefer kcal; if not available, try kJ -> convert to kcal (1 kcal = 4.184 kJ)
                      double _getCalories() {
                        final kcal = nutr?.getValue(
                          Nutrient.energyKCal,
                          PerSize.oneHundredGrams,
                        );
                        if (kcal != null) return kcal;
                        final kj = nutr?.getComputedKJ(PerSize.oneHundredGrams);
                        if (kj != null) return kj / 4.184;
                        return 0.0;
                      }

                      return FoodItem(
                        brand: product.brands ?? 'Unknown Brand',
                        productName: product.productName ?? 'Unknown Product',
                        calories: _getCalories(),
                        carbs: _get(Nutrient.carbohydrates),
                        fats: _get(Nutrient.fat),
                        proteins: _get(Nutrient.proteins),
                        ingredientsText:
                            product.ingredientsText ?? 'No ingredients listed',
                      );
                    }).toList() ??
                    [];
              });
            },
          ),
        ),
      ),
      body: ListView(
        children: foods
            .map(
              (food) => FoodListTileWidget(
                food: food,
                isSelected: false,
                onSelectedFood: onSelectedFood,
              ),
            )
            .toList(),
      ),
      backgroundColor: Theme.of(context).primaryColor,
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

  const FoodListTileWidget({
    super.key,
    required this.food,
    required this.isSelected,
    required this.onSelectedFood,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onSelectedFood(food),
      title: Text(food.productName),
      subtitle: Text(food.calories.toString()),
    );
  }
}
