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

class _FoodSelectorState extends State<FoodSelector>  with TickerProviderStateMixin{
  final GetQuery query = GetQuery();
  List<FoodItem> foods = []; // <--- state field (was a local var before)
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose () {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column( // TODO: Change so the header is not fixed to the top (disappears when scrolling down)
        children: [
          Padding(padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0,),
          ),
          // Header
          Row(
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
              Container(
                width: 295,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((16.0)),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      width: 210,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                          hintText: 'Search all food...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(16.0),

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
                                      nutr?.getValue(n, PerSize.oneHundredGrams) ??
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
                                        product.productName ?? 'Unknown Product',
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
                    const Icon(Icons.filter_alt, size: 28,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 9.0,),
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
          Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white
            ),
            child: TabBar(
              indicatorColor: Colors.transparent,
              controller: _tabController,
              tabs: [
                // All tab
                Container(
                  width: 100,
                  height: 23,
                  decoration: BoxDecoration(
                    color: _tabController.index == 0 ? getThemeData().primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: BoxBorder.all(
                      color: getThemeData().primaryColor
                  )
                  ),
                  child: Tab(
                    height: 20,
                    child: Text(
                      "All",
                      style: TextStyle(
                        color: Colors.black
                      ),)
                    ),
                ),
                // Favourites tab
                Tab(
                  text: 'Favourites',
                  height: 20,),
                // Custom tab
                Tab(text: 'Custom'),
              ],
              ),
          ),
          // Body
             Expanded(
               child: TabBarView(
                controller: _tabController,
                 children: <Widget> [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                    final food = foods[index];
                    return FoodListTileWidget(
                            food: food,
                            isSelected: false,
                            onSelectedFood: onSelectedFood,
                    );
                    },
                  ),
               
                  const Text("here are my favourites"),
                  const Text("here are my custom foods")
                            
                 ]
               ),
             ),
            ]
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
