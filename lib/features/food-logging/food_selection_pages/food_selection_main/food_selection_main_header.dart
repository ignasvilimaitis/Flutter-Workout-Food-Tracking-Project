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
                            onChanged: onSearchChanged,
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
              SizedBox(height: 30.0,),
              
            ],
          );
  }
}