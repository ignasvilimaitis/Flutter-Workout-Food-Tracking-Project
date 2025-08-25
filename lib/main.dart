import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/routes.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/views/logging_food/food_logging_view.dart';
import 'package:flutter_application_1/views/registration/login_view.dart';
import 'package:flutter_application_1/views/registration/register_view.dart';
import 'package:flutter_application_1/views/registration/settings_screen.dart';
import 'package:flutter_application_1/views/registration/verify_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 124, 212, 7)),
      ),
      home: const HomePage(),
      routes: {
        registerRoute: (context) => const RegisterView(),
        loginRoute: (context) => const LoginView(),
        settingsRoute: (context) => const SettingsScreen(),
        verifyEmailRoute:(context) => const VerifyEmail(),
        loggingFoodRoute: (context) => FoodLoggingView(),
      },
    ),
    );
  }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (user.emailVerified) {
                    return SettingsScreen();
                  }
                } else {
                  return const LoginView();
                }
              default:
                return const CircularProgressIndicator();
            }
            throw Exception();
          },
        );
  }
}

class MainUI extends StatefulWidget {
  const MainUI({super.key});

  @override
  State<MainUI> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: const Text("Settings")),
    Center(child: const Text("Test")),
  ];
  
  void _onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: 
      BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.temple_buddhist),
          label: 'Test',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onTappedItem,
      ),
      appBar: AppBar(
        title: const Text("Main Menu")
      ),
    );    
  }
}

