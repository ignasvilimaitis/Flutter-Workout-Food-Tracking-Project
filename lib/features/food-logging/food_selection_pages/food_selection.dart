import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/food_item.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_selection_all.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_selection_custom.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_selection_favourites.dart';
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
  List<FoodItem> searchedFoods = []; // <--- state field (was a local var before)
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
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
            children: [
              buildHeader(context),
              buildBody(context),
            ],
          ),
        ),
    );

  }

Column buildHeader(BuildContext context) {
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
                            onChanged: (String value) async {
                              print('Searching for: $value');
                              if (value.isEmpty || value.trim().isEmpty) {
                                setState(() {
                                  searchedFoods = [];
                                  return;
                                });
                              }
                              SearchResult? result = await query.searchProducts(
                                value,
                              );

                              setState(() {
                                searchedFoods =  query.getSearchResults(result);
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
              
            ],
          );
  }

  void onSelectedFood(FoodItem food) {
    Provider.of<RecentFoods>(context, listen: false).addRecentFood(food);
    //foods.clear();
    Navigator.pop(context, food);
  }

  Consumer<RecentFoods> buildBody (BuildContext context) { // For now this works but also needs to go back to recent
  // view when the search is cleared, some sort of live updates must happen when the search bar is clear
      return Consumer<RecentFoods>( // will have to convert this to a stream builder/future builder
      // get the food data from OFF Json, convert it to FoodItem and add to a List<FoodItem>
      builder: (context, recentFoodList, child) {
        if (searchedFoods.isEmpty) {
        return Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      FoodSelectorAll(),
                      FoodSelectionFavourites(),
                      FoodSelectionCustom(),
                    ]
                  ),
        );
        } else if (searchedFoods.isNotEmpty) {
          return Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 390,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchedFoods.length,
                  itemBuilder: (context, index) {
                    final food = searchedFoods[index];
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
            ),
          );

        } else {
          return Text("Failed");
        }
      }
      );
}
}


