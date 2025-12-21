import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/local_time.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/features/food-logging/data/food_data_source.dart';
import 'package:flutter_application_1/features/food-logging/data/food_repository.dart';
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
  String selectedDate = LocalTime().currentDate; // Initially start with today's date
  FoodRepository foodRepository = FoodRepository(FoodDataSource());

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();

  }

@override
@override
Widget build(BuildContext context) {
  return Scaffold(
    bottomNavigationBar: CustomBottomAppBar(module: 'food'),
    body: Consumer3<TotalMacros, MacroGoal, CurrentMacroDisplay>(
      builder: (context, totalMacros, macroGoals, currentDisplayedMacroType, child) {
        return SafeArea(
          child: FutureBuilder(
            future: foodRepository.getCurrentDay(selectedDate),
            builder: (context, asyncSnapshot) {
              if(asyncSnapshot.hasData) {
              return Column(
                children: [
                  // Header - Fixed height
                  buildHeader(),
                  // Scrollable content area
                  Expanded(
                    child: buildScrollableContent(currentDisplayedMacroType) 
                  )
                ],
              );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
        );
      },
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
  );
}

Widget buildScrollableContent(CurrentMacroDisplay currentDisplayedMacroType) {
  return ListView(
    padding: const EdgeInsets.only(
      bottom: 10,
      top: 10,
    ),
    physics: const AlwaysScrollableScrollPhysics(),
    children: [
      buildScrollableWidgetRow(),
      const SizedBox(height: 20),
      buildBody(currentDisplayedMacroType),
    ],
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
Color getMacroColor(CurrentMacroDisplay currentDisplayedMacroType) {
  switch (currentDisplayedMacroType.getCurrentDisplay()) {
    case MacroType.energy:
      return getThemeData().primaryColor;
    case MacroType.protein:
      return Colors.green;
    case MacroType.carbs:
      return Colors.blue;
    case MacroType.fat:
      return Colors.orange;
  }
}
MacroType getNextMacroType(CurrentMacroDisplay currentDisplayedMacroType) {
  switch (currentDisplayedMacroType.getCurrentDisplay()) {
    case MacroType.energy:
      return MacroType.protein;
    case MacroType.protein:
      return MacroType.carbs;
    case MacroType.carbs:
      return MacroType.fat;
    case MacroType.fat:
      return MacroType.energy;
  }
}
Widget buildHeader() {
    return Row(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
        child: UIButton(
          function: 'Return',
          iconData: Icons.keyboard_return,
        ),
      ),
      Expanded(
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 10.0, 12.0, 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((16.0)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                  onPressed: () {
                    setState(() {
                      selectedDate = LocalTime().getPreviousDate(selectedDate);
                    });
                    print(selectedDate);
                  },
                icon: Icon(Icons.arrow_left),
                iconSize: 50),
              Spacer(),
              Text(
                  LocalTime().formatEnglishDate(selectedDate),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                                  onPressed: () {
                    setState(() {
                      selectedDate = LocalTime().getAheadDate(selectedDate);
                    });
                  },
                icon: Icon(Icons.arrow_right),
                iconSize: 50),
            ],
          ),
        ),
      ),
    ],
  );
}
Widget buildScrollableWidgetRow() {
  return Padding(
    padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 0.0),
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
  );
}
Widget buildBody(CurrentMacroDisplay currentDisplayedMacroType) {
  return Container(
      margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  currentDisplayedMacroType.setCurrentDisplay(getNextMacroType(currentDisplayedMacroType)
                  );
                },
                  label: (getCurrentMacro(currentDisplayedMacroType)),
                  icon: Icon(Icons.swap_horiz_rounded,
                  color: getMacroColor(currentDisplayedMacroType)
              
                  ),
              ),
                SizedBox(width: 10,)
                
              
            ],
          ),
          DiaryWidgetV2(diaryName: 'Breakfast', diaryDate: selectedDate, diaryId: 1,),
          SizedBox(height: 20,),
          DiaryWidgetV2(diaryName: 'Lunch', diaryDate: selectedDate, diaryId: 2,),
          SizedBox(height: 20,),
          DiaryWidgetV2(diaryName: 'Dinner', diaryDate: selectedDate, diaryId: 3,),
          SizedBox(height: 20,),
          DiaryWidgetV2(diaryName: 'Snacks', diaryDate: selectedDate, diaryId: 4,),
        ],
      ),
    );
}
}
