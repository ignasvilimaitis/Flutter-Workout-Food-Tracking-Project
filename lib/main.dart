import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/features/food-logging/food_logging_view.dart';
import 'package:flutter_application_1/features/food-logging/food_selection.dart';
import 'package:flutter_application_1/features/home/presentation/home.dart';
import 'package:flutter_application_1/features/settings/presentation/settings_screen.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => FoodModel(),
      child: MyApp(),
    )
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
      routes: {
        settingsRoute: (context) => const SettingsScreen(),
        homeRoute: (context) => HomePage(),
        foodLoggingRoute: (context) => const FoodLoggingView(),
        foodSelectionRoute: (context) => FoodSelector(),
      },
    );
  }
}