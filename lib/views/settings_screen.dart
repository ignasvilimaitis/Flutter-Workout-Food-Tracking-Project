import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container( // Settings container
          //alignment: Alignment.center,
          margin: const EdgeInsets.all(12.0),
          child: Icon(Icons.settings),
          ),
          const Text("Settings"),
          Container(
            padding: EdgeInsets.all(30), // Padding so settings is in the middle (not true center)
          )
          ],
        ),
        leading: Container(
          child: Icon(Icons.arrow_back_rounded),),
      )
  );
  }
}