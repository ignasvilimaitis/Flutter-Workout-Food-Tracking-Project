import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/widgets/tab_bar.dart';

class FoodSelectionMainHeader extends StatelessWidget {
  FoodSelectionMainHeader({super.key, required this.onSearchChanged, required this.tabController});
  final Function(String) onSearchChanged;
  final TabController tabController;
  final List<String> tabs = ['All', 'Favourites', 'Custom',];

  @override
  Widget build(BuildContext context) {
          return Column(
            // TODO: Change so the header is not fixed to the top (disappears when scrolling down) (sliverappbar?)
            children: [
              // Header
              Row(
                // Back button
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(12.0, 0.0, 10.0, 0.0),
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
                  // Search container (including search icon, textfield and filter)
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular((16.0)),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                color: const Color.fromARGB(255, 82, 82, 82),
                                fontWeight: FontWeight.w100,
                                fontSize: 12.0,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 10.0,
                                ),
                                hintText: 'Search all food...',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onChanged: onSearchChanged,
                            ),
                          ),
                          const Icon(Icons.filter_alt, size: 28),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
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
                ],
              ),
              SizedBox(height: 6),
              //Tab bar (all, favourites, custom)
              Container(
                margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  controller: tabController,
                  tabs: tabs.asMap().entries.map((entry) { // Maps each tab from tabs (the list of strings) with an index so that it can be referenced
                  // .. for the tab controller in order to control which tab is highlighted (and selected)
                    final index = entry.key;
                    final label = entry.value;
                    return FoodTabBar(
                      text: label,
                      isSelected: tabController.index == index,
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 25.0,),
              
            ],
          );
  }
}