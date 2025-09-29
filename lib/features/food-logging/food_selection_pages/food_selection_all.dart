import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/food_item.dart';
import 'package:flutter_application_1/features/food-logging/openfoodfacts_queries/get_query.dart';
import 'package:flutter_application_1/features/food-logging/states/recent_foods.dart';
import 'package:flutter_application_1/features/food-logging/widgets/food_list_tile.dart';
import 'package:flutter_application_1/features/food-logging/widgets/tab_bar.dart';
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
  final RecentFoods recentFoods = RecentFoods();
  final List<String> tabs = ['All', 'Favourites', 'Custom',];

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
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 16.0,
                  right: 16.0,
                ),
              ),
              // Header
              Row(
                // Back button
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
                    // Search container (including search icon, textfield and filter)
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
                                borderSide: BorderSide(width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onSubmitted: (String value) async {
                              print('Searching for: $value');
                              SearchResult? result = await query.searchProducts(
                                value,
                              );

                              setState(() {
                                foods =  query.getSearchResults(result);
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 7.0),
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
              SizedBox(height: 6),
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
                  tabs: tabs.asMap().entries.map((entry) { // Maps each tab from tabs (the list of strings) with an index so that it can be referenced
                  // .. for the tab controller in order to control which tab is highlighted (and selected)
                    final index = entry.key;
                    final label = entry.value;
                    return FoodTabBar(
                      text: label,
                      isSelected: _tabController.index == index,
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30.0,),
              // Body
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: foods.isEmpty
                            ? recentFoodList.getRecentFoods().length
                            : foods.length,
                        itemBuilder: (context, index) {
                          final recentFoods = recentFoodList.getRecentFoods();
                          final food = foods.isEmpty
                              ? recentFoods[index]
                              : foods[index];
                          print(recentFoodList.getRecentFoods());
                          return Column(
                            children: [
                              FoodListTileWidget(
                                ifRecent: foods.isEmpty ? true : false,
                                food: food,
                                isSelected: false,
                                onSelectedFood: onSelectedFood,
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const Text("here are my favourites"),
                    const Text("here are my custom foods"),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void onSelectedFood(FoodItem food) {
    Provider.of<RecentFoods>(context, listen: false).addRecentFood(food);
    //foods.clear();
    Navigator.pop(context, food);
  }
}

