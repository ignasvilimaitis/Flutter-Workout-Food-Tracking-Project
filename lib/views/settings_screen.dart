import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        margin: EdgeInsets.fromLTRB(
          8.0,
          24.0,
          8.0,
          15.0
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((8.0)),
          color: Colors.white,
        ),
        child:
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      TextButton(
                        onPressed: () {},
                        child: Icon(Icons.arrow_back_ios_sharp)
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.directional(
                          start: 75.0,
                          top: 40.0
                        )
                      ),
                      Container( // Settings container
                        margin: const EdgeInsets.all(12.0),
                        child: Icon(Icons.settings),
                      ),
                      const Text(
                        "Settings"
                        textScaler: ,

                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.directional(
                          start: 135.0,
                          top: 45.0,
                        ))
                  ],
                ),
              ],
            ),
      ),
      backgroundColor: Colors.grey,
    );
  }
}