import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/database/app_database.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_diary.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_selection_main/food_selection.dart';
import 'package:flutter_application_1/features/food-logging/states/recent_foods.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:flutter_application_1/features/home/presentation/home.dart';
import 'package:flutter_application_1/features/settings/presentation/settings_screen.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

import './features/workout-logging/presentation/workout_base.dart' as workout_module show BaseLayout;
import './features/workout-logging/presentation/widgets/workout/workout_services.dart' show WorkoutService;

import './core/services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService().init(); // shared_preferences initialization

  OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'Gym & Food Tracker', version: '1.0.0');
  OpenFoodAPIConfiguration.globalLanguages = [OpenFoodFactsLanguage.ENGLISH];
  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.UNITED_KINGDOM;

  AppDatabase.instance.database; // Initialize the database

  runApp(
    MultiProvider(
      providers: [
        // Food logging providers
        ChangeNotifierProvider(create: (context) => DiaryFoodList()),
        ChangeNotifierProvider(create: (context) => TotalMacros()),
        ChangeNotifierProvider(create: (context) => MacroGoal(),),
        ChangeNotifierProvider(create: (context) => RecentFoods(),),
        ChangeNotifierProvider(create: (context) => CurrentMacroDisplay(),),

        // Workout logging providers
        ChangeNotifierProvider(create: (context) => WorkoutService())
      ],
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym & Food Tracker',
      debugShowCheckedModeBanner: false,
      theme: getThemeData(),
      home: HomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case settingsRoute:
            return MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
              settings: settings,
            );
          case homeRoute:
            return MaterialPageRoute(
              builder: (context) => HomePage(),
              settings: settings,
            );
          case foodLoggingRoute:
            return MaterialPageRoute(
              builder: (context) => const FoodLoggingView(),
              settings: settings,
            );
          case (foodSelectionRoute):
            return MaterialPageRoute<FoodItem>
            (builder: (context) => FoodSelector(),
            settings: settings,
           );
          case (workoutHomeRoute):
            return MaterialPageRoute(
              builder: (context) => workout_module.BaseLayout(),
              settings: settings,
            );
        }
        return null;
      }
    );
  }
}