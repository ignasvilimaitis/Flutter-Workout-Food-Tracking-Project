import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/food_logging_view.dart';
import 'package:flutter_application_1/features/food-logging/food_selection.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:flutter_application_1/features/home/presentation/home.dart';
import 'package:flutter_application_1/features/settings/presentation/settings_screen.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'Gym & Food Tracker', version: '1.0.0');
  OpenFoodAPIConfiguration.globalLanguages = [OpenFoodFactsLanguage.ENGLISH];
  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.UNITED_KINGDOM;
  runApp(
    MultiProvider(
      providers: [
    ChangeNotifierProvider(create: (context) => DiaryFoodList()),
    ChangeNotifierProvider(create: (context) => TotalMacros()),
    ChangeNotifierProvider(create: (context) => MacroGoal(),)
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
        }
        }
    );
  }
}