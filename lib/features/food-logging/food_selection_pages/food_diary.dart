import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/local_time.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:flutter_application_1/features/food-logging/widgets/diary_widget_v2.dart';
import 'package:flutter_application_1/features/food-logging/widgets/progress_bar.dart';
import 'package:flutter_application_1/features/food-logging/widgets/ui_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/core/enums.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FoodLoggingView extends StatefulWidget {
  const FoodLoggingView({super.key});

  @override
  State<FoodLoggingView> createState() => _FoodLoggingViewState();
}

class _FoodLoggingViewState extends State<FoodLoggingView> {
  late PageController _pageController;
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
      body: Consumer3<TotalMacros, MacroGoal, CurrentMacroDisplay>(
        builder: (context, totalMacros, macroGoals, currentDisplayedMacroType, child) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: [
                  // Header
                  Row(
                    children: [
                      SizedBox(width: 10),
                      UIButton(
                        function: 'Return',
                        iconData: Icons.keyboard_return,
                      ),
                      SizedBox(width: 15),
                      Container(
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
                                LocalTime().today,
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 10.0, 16.0, 0.0),
                    child: Container(
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
                              Column(
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
                                    // Protein Progress Bar
                                     MacroProgressBar(
                                      color: const Color.fromARGB(255, 106, 206, 110),
                                      macroName: 'Protein',
                                      macroType: MacroType.protein
                                      ),
                                  SizedBox(height: 25,),
                                  // Carbs Progress Bar
                                    MacroProgressBar(
                                      color: Colors.blueAccent,
                                      macroName: 'Carbs',
                                      macroType: MacroType.carbs
                                      ),
                                      SizedBox(height: 25,),
                                    // Fat Progress Bar
                                    MacroProgressBar(
                                      color: Colors.orange,
                                      macroName: 'Fat',
                                      macroType: MacroType.fat
                                      ),
                                  ],
                                ),
                              const Text("Page 2"),
                              const Text("Page 3"),
                              const Text("Page 4"),
                              const Text("Page 5"),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SmoothPageIndicator(
                              effect: WormEffect(
                                dotHeight: 12,
                                dotWidth: 12,
                                spacing: 8,
                                dotColor: Colors.grey,
                                activeDotColor: Theme.of(context).colorScheme.primary,
                              ),
                              controller: _pageController,
                              count: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                  children: [
                     Container(
                      margin: EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((20.0)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 178), // TODO: Temp fix to put in the middle
                                const Text('Log',
                                style: TextStyle(
                                  fontSize: 18
                                ),
                                ),
                                Spacer(),
                                TextButton.icon(
                                  iconAlignment: IconAlignment.end,
                                  onPressed: () {
                                    currentDisplayedMacroType.setCurrentDisplay(
                                      currentDisplayedMacroType.getCurrentDisplay() == MacroType.protein
                                      ? MacroType.carbs
                                      : currentDisplayedMacroType.getCurrentDisplay() == MacroType.carbs
                                      ? MacroType.fat
                                      : currentDisplayedMacroType.getCurrentDisplay() == MacroType.fat
                                      ? MacroType.energy
                                      : MacroType.protein
                                    );
                                  },
                                    label: (getCurrentMacro(currentDisplayedMacroType)),
                                   icon: Icon(Icons.swap_horiz_rounded,
                                   color: currentDisplayedMacroType.getCurrentDisplay() == MacroType.protein ?
                                   Colors.green : currentDisplayedMacroType.getCurrentDisplay() == MacroType.fat ? Colors.orange
                                   : currentDisplayedMacroType.getCurrentDisplay() == MacroType.carbs ? Colors.blue : getThemeData().primaryColor,),

                                   ),
                                  SizedBox(width: 10,)
                                   

                              ],
                            ),
                            DiaryWidgetV2(diaryName: 'Breakfast'),
                            SizedBox(height: 20,),
                            DiaryWidgetV2(diaryName: 'Lunch'),
                            SizedBox(height: 20,),
                            DiaryWidgetV2(diaryName: 'Dinner'),
                            SizedBox(height: 20,),
                            DiaryWidgetV2(diaryName: 'Snacks'),
                            SizedBox(height: 20,),

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

// Helper function to get the label string + color for macro view switching
Widget getCurrentMacro(CurrentMacroDisplay currentDisplayedMacroType) {
  switch (currentDisplayedMacroType.getCurrentDisplay()) {
    case MacroType.energy:
      return Text("Kcals");
    case MacroType.protein:
      return Text("Protein",
      style: TextStyle(
        color: Colors.green
      ),
      );
    case MacroType.carbs:
      return Text("Carbs",
      style: TextStyle(
        color: Colors.blue
      ),
      );
    case MacroType.fat:
      return Text("Fat",
      style: TextStyle(
        color: Colors.orange
      ),
      );
  }
}
}
