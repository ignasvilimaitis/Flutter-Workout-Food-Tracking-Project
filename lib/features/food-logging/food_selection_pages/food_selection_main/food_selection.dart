import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/debouncer.dart';
import 'package:flutter_application_1/features/food-logging/data/food_data_source.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_selection_all/food_selection_all.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_selection_custom/food_selection_custom.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_selection_favourites/food_selection_favourites.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_selection_main/food_selection_main_header.dart';
import 'package:flutter_application_1/features/food-logging/openfoodfacts_queries/get_query.dart';
import 'package:flutter_application_1/features/food-logging/states/recent_foods.dart';
import 'package:flutter_application_1/features/food-logging/widgets/food_list_tile.dart';
import 'package:flutter_application_1/features/food-logging/widgets/no_food_found.dart';
import 'package:provider/provider.dart';

class FoodSelector extends StatefulWidget {
  const FoodSelector({super.key});

  @override
  State<FoodSelector> createState() => _FoodSelectorState();
}

class _FoodSelectorState extends State<FoodSelector>
    with TickerProviderStateMixin {
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  final FoodDataSource foodDataSource = FoodDataSource();
  List<FoodItem> searchedFoods = [];
  String _lastSearch = ''; // <-- new field
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
              FoodSelectionMainHeader(
                onSearchChanged: (searchText) {
                  debouncer.run(() async {
                    if (searchText != _lastSearch) {
                      final results = await foodDataSource.getSearchedFoods(searchText);
                      print(results);
                      setState(() {
                        searchedFoods = results;
                        _lastSearch = searchText;
                      });
                    }
                  });
                },
                tabController: _tabController,
              ),
              buildBody(context),
            ],
          ),
        ),
    );

  }

  void onSelectedFood(FoodItem food) {
    Provider.of<RecentFoods>(context, listen: false).addRecentFood(food);
    //foods.clear();
    Navigator.pop(context, food);
  }

  Consumer<RecentFoods> buildBody (BuildContext context) { 
      return Consumer<RecentFoods>( 
      builder: (context, recentFoodList, child) {
        return Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _lastSearch.isEmpty
                ? FoodSelectorAll()
                : (searchedFoods.isEmpty ? NoFoodFoundPopUp() : searchFood()),
              // Favourites tab
              FoodSelectionFavourites(),
              // Custom tab
              FoodSelectionCustom(),
            ],
          ),
        );
        }
      );
}

Widget searchFood() {
  if (searchedFoods.isEmpty) {
    return NoFoodFoundPopUp();
  } else {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: searchedFoods.length,
      itemBuilder: (context, index) {
        final food = searchedFoods[index];
        return FoodListTileWidget(
          food: food,
          isSelected: false,
          onSelectedFood: onSelectedFood,
        );
      },
    ),
  );
  }
}
}


