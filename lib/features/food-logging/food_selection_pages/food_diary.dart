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
  final selectedDate = LocalTime().currentDate;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodViewModel>().loadForDate(selectedDate);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomAppBar(module: 'food'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Consumer2<CurrentMacroDisplay, FoodViewModel>(
          builder: (context, macroDisplay, foodVM, _) {
            return Column(
              children: [
                _buildHeader(context, foodVM),
                Expanded(
                  child: _buildScrollableContent(macroDisplay),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _buildHeader(BuildContext context, FoodViewModel foodVM) {
    final selectedDate = foodVM.selectedDate;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: UIButton(
            function: 'Return',
            iconData: Icons.keyboard_return,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  iconSize: 40,
                  onPressed: () {
                    final newDate =
                        LocalTime().getPreviousDate(selectedDate);
                    foodVM.loadForDate(newDate);
                  },
                ),
                const Spacer(),
                Text(
                  LocalTime().formatEnglishDate(selectedDate),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  iconSize: 40,
                  onPressed: () {
                    final newDate =
                        LocalTime().getAheadDate(selectedDate);
                    foodVM.loadForDate(newDate);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- BODY ----------------

  Widget _buildScrollableContent(CurrentMacroDisplay macroDisplay) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        _buildProgressPager(),
        const SizedBox(height: 20),
        _buildDiarySection(macroDisplay),
      ],
    );
  }

  Widget _buildProgressPager() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: _pageController,
              children: const [
                _MacroPage(),
                Center(child: Text("Page 2")),
                Center(child: Text("Page 3")),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor:
                      getThemeData().primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiarySection(CurrentMacroDisplay macroDisplay) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildMacroSwitcher(macroDisplay),
          const SizedBox(height: 10),
          const DiaryWidgetV2(
              diaryName: 'Breakfast', diaryId: 1),
          const SizedBox(height: 20),
          const DiaryWidgetV2(
              diaryName: 'Lunch', diaryId: 2),
          const SizedBox(height: 20),
          const DiaryWidgetV2(
              diaryName: 'Dinner', diaryId: 3),
          const SizedBox(height: 20),
          const DiaryWidgetV2(
              diaryName: 'Snacks', diaryId: 4),
        ],
      ),
    );
  }

  Widget _buildMacroSwitcher(CurrentMacroDisplay macroDisplay) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Log', style: TextStyle(fontSize: 18)),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            macroDisplay.setCurrentDisplay(
              _nextMacro(macroDisplay.getCurrentDisplay()),
            );
          },
          icon: const Icon(Icons.swap_horiz),
          label: Text(
            macroDisplay.getCurrentDisplay().name,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  MacroType _nextMacro(MacroType type) {
    switch (type) {
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
}

// ---------------- MACRO PAGE ----------------

class _MacroPage extends StatelessWidget {
  const _MacroPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 10),
        Text('Targets',
            style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        MacroProgressBar(
          macroName: 'Protein',
          macroType: MacroType.protein,
          color: Colors.green,
        ),
        SizedBox(height: 25),
        MacroProgressBar(
          macroName: 'Carbs',
          macroType: MacroType.carbs,
          color: Colors.blue,
        ),
        SizedBox(height: 25),
        MacroProgressBar(
          macroName: 'Fat',
          macroType: MacroType.fat,
          color: Colors.orange,
        ),
      ],
    );
  }
}
