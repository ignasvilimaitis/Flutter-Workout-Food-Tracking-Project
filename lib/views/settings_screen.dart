import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/settings_button.dart';

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
          borderRadius: BorderRadius.circular((16.0)),
          color: Colors.white,
        ),
        child:
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},// return to menu
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                      ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.directional(
                      start: 45.0,
                      top: 40.0,
                      end: 30.0
                    )
                  ),
                  Container( // Settings container
                    margin: const EdgeInsets.fromLTRB(
                      0.0,
                      0.0,
                      5.0,
                      0.0,
                      ),
                    child: Icon(Icons.settings),
                  ),
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      ),                      
                  ),
                  Padding( // Padding in attempt to center the settings (i'm aware this can definitely be done differently)
                    padding: EdgeInsetsGeometry.directional(
                      end: 135.0,
                      top: 45.0,
                    ))
                ],
              ),
              UIButton(
                icon: Icons.line_weight,
                text: "Profile",
                onPressed: () {}),
              UIButton(
                icon: Icons.pie_chart,
                text: "Data",
                onPressed: () {}),
              UIButton(
                icon: Icons.format_paint,
                text: "Themes",
                onPressed: () {}),
              UIButton(
                icon: Icons.language,
                text: "Locales",
                onPressed: () {}),
              UIButton(
                icon: Icons.info_rounded,
                text: "About",
                onPressed: () {}),
              UIButton(
                icon: Icons.bug_report,
                text: "Bugs",
                onPressed: () {}),
              UIButton(
                icon: Icons.support,
                text: "Support",
                onPressed: () {}),
            ],
          ),
      ),
      backgroundColor: Colors.grey,
    );
  }
}