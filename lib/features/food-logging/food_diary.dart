import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:flutter_application_1/features/food-logging/widgets/diary_widget_v2.dart';
import 'package:flutter_application_1/features/food-logging/widgets/progress_bar.dart';
import 'package:flutter_application_1/features/food-logging/widgets/ui_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

DateTime date = DateTime.now();
String today = '${date.day}th ${DateFormat('MMMM').format(date)} ${date.year}';

class FoodLoggingView extends StatefulWidget {
  const FoodLoggingView({super.key});

  @override
  State<FoodLoggingView> createState() => _FoodLoggingViewState();
}

class _FoodLoggingViewState extends State<FoodLoggingView> {
  late PageController _pageController;
  late TabController _tabController;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // _tabController = TabController(length: 4, vsync: ScrollableState());
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    // _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<TotalMacros, MacroGoal>(
        builder: (context, totalMacros, macroGoals, child) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: [
                  // Header
                  Padding(padding: EdgeInsetsGeometry.only(top: 15)),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      UIButton(
                        function: 'Return',
                        iconData: Icons.keyboard_return,
                      ),
                      SizedBox(width: 15),
                      Container(
                        width: 330,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((16.0)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_left, size: 50),
                            SizedBox(width: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Text(
                                today,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Icon(Icons.arrow_right, size: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Scrollable Widget Row
                  Container(
                    margin: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0.0),
                    width: 400,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((20.0)),
                      color: Colors.white,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        PageView(
                          controller: _pageController,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text(
                                      'Targets',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Carbs Progress Bar
                                  MacroProgressBar(
                                    color: Colors.blueAccent,
                                    macroName: 'Carbs',
                                    macroType: MacroType.carbs
                                    ),
                                    SizedBox(height: 25,),
                                  MacroProgressBar(
                                    color: Colors.green,
                                    macroName: 'Protein',
                                    macroType: MacroType.protein
                                    ),
                                    SizedBox(height: 25,),
                                  MacroProgressBar(
                                    color: Colors.orange,
                                    macroName: 'Fat',
                                    macroType: MacroType.fat
                                    ),
                                ],
                              ),
                            ),
                            const Text("Page 2"),
                            const Text("Page 3"),
                            const Text("Page 4"),
                            const Text("Page 5"),
                          ],
                        ),
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsetsGeometry.only(top: 15)),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((20.0)),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.97,
                    child: Column(
                      children: [
                        const Text("Log"),
                        DiaryWidgetV2(diaryName: "Breakfast"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
