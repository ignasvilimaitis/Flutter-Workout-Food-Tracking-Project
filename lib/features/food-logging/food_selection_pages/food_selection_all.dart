import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/openfoodfacts_queries/get_query.dart';
import 'package:flutter_application_1/features/food-logging/states/recent_foods.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

class FoodSelector extends StatefulWidget {
  const FoodSelector({super.key});

  @override
  State<FoodSelector> createState() => _FoodSelectorState();
}

class _FoodSelectorState extends State<FoodSelector>
    with TickerProviderStateMixin {
  final GetQuery query = GetQuery();
  List<FoodItem> foods = []; // <--- state field (was a local var before)
  late TabController _tabController;
  int _currentPageIndex = 0;
  final RecentFoods recentFoods = RecentFoods();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); //updates state each time tab is switched
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RecentFoods>(
        builder: (context, recentFoodList, child) {
        return Column(
          // TODO: Change so the header is not fixed to the top (disappears when scrolling down)
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
            ),
            // Header
            Row( // Back button
              children: [
                Padding(
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
                Container( // Search container (including search icon, textfield and filter)
                  width: 290,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((16.0)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 5.0),
                      SizedBox(
                        width: 210,
                        child: TextField(
                          style: TextStyle(
                            color: const Color.fromARGB(255, 82, 82, 82),
                            fontWeight: FontWeight.w100,
                            fontSize: 12.0,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 10.0,
                            ),
                            hintText: 'Search all food...',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onSubmitted: (String value) async {
                            print('Searching for: $value');
                            SearchResult? result = await query.searchProducts(
                              value,
                            );
                            List<Product>? products = result?.products;
        
                            setState(() {
                              foods =
                                  products?.map((product) {
                                    final nutr = product.nutriments;
        
                                    // helper to read most nutrients per 100g
                                    double _get(Nutrient n) =>
                                        nutr?.getValue(
                                          n,
                                          PerSize.oneHundredGrams,
                                        ) ??
                                        0.0;
                                    // Gotta use helper methods for all the macros since they removed direct getters, e.g. product.carbohydrates
                                    // Now you have to read through enum values
        
                                    // Calories: prefer kcal; if not available, try kJ -> convert to kcal (1 kcal = 4.184 kJ)
                                    double _getCalories() {
                                      final kcal = nutr?.getValue(
                                        Nutrient.energyKCal,
                                        PerSize.oneHundredGrams,
                                      );
                                      if (kcal != null) return kcal;
                                      final kj = nutr?.getComputedKJ(
                                        PerSize.oneHundredGrams,
                                      );
                                      if (kj != null) return kj / 4.184;
                                      return 0.0;
                                    }
        
                                    return FoodItem(
                                      brand: product.brands ?? 'Unknown Brand',
                                      productName:
                                          product.productName ??
                                          'Unknown Product',
                                      calories: _getCalories(),
                                      carbs: _get(Nutrient.carbohydrates),
                                      fats: _get(Nutrient.fat),
                                      proteins: _get(Nutrient.proteins),
                                      ingredientsText:
                                          product.ingredientsText ??
                                          'No ingredients listed',
                                    );
                                  }).toList() ??
                                  [];
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 7.0,),
                      const Icon(Icons.filter_alt, size: 28),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
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
                      icon: Icon(Icons.qr_code),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6,),
            //Tab bar (all, favourites, custom)
            Container(
              width: 390,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                controller: _tabController,
                tabs: [
                  // All tab
                  Container(
                    width: 120,
                    height: 23,
                    decoration: BoxDecoration(
                      color: _tabController.index == 0
                          ? getThemeData().primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: BoxBorder.all(color: getThemeData().primaryColor),
                    ),
                    child: Tab(
                      height: 20,
                      child: Text("All", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  // Favourites tab
                  Container(
                    width: 120,
                    height: 23,
                    decoration: BoxDecoration(
                      color: _tabController.index == 1
                          ? getThemeData().primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: BoxBorder.all(color: getThemeData().primaryColor),
                    ),
                    child: Tab(
                      height: 20,
                      child: Text(
                        "Favourites",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  // Custom tab
                  Container(
                    width: 120,
                    height: 23,
                    decoration: BoxDecoration(
                      color: _tabController.index == 2
                          ? getThemeData().primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: BoxBorder.all(color: getThemeData().primaryColor),
                    ),
                    child: Tab(
                      height: 20,
                      child: Text(
                        "Custom",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Expanded(
              child:
              TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: foods.isEmpty ? recentFoodList.getRecentFoods().length : foods.length,
                    itemBuilder: (context, index) {
                      final recentFoods = recentFoodList.getRecentFoods();
                      final food = foods.isEmpty ? recentFoods[index] : foods[index];
                      print(recentFoodList.getRecentFoods());
                      return FoodListTileWidget(
                        food: food,
                        isSelected: false,
                        onSelectedFood: onSelectedFood,
                      );
                    },
                  ),
        
                  const Text("here are my favourites"),
                  const Text("here are my custom foods"),
                ],
              ),
            ),
          ],
        );
        }
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void onSelectedFood(FoodItem food) {
    Provider.of<RecentFoods>(context, listen: false).addRecentFood(food);
    foods.clear();
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
