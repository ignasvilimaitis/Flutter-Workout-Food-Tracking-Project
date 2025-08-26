import 'package:flutter/material.dart';

import 'package:flutter_application_1/features/home/presentation/home.dart';
import 'package:flutter_application_1/features/settings/presentation/settings_screen.dart';

import 'package:flutter_application_1/core/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Gym & Food Tracker',
      debugShowCheckedModeBanner: false,
      theme: getThemeData(),
      home: HomePage(),
      routes: {'/settings/': (context) => const SettingsScreen()},
    ),
  );
}