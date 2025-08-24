import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/routes.dart';
import 'package:flutter_application_1/utilities/show_log_out_dialog.dart';
import 'package:flutter_application_1/widgets/settings_background.dart';
import 'package:flutter_application_1/widgets/settings_button.dart';
import 'dart:developer' as devtools show log;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsUIBackground(
      child:Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},// TODO: return to menu
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                      ),
                  ),
                  Expanded(
                    child: SizedBox(),
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
                      end: 148.0,
                      top: 45.0,
                    ))
                ],
              ),
              const Text(
                "Personal",
                style: TextStyle(
                  fontSize: 12.0
                ),
              ),
              Padding(padding: EdgeInsetsGeometry.directional(top: 5)),                
              UIButton(
                icon: Icons.line_weight,
                text: "Profile",
                onPressed: () {}
              ),
              UIButton(
                icon: Icons.pie_chart,
                text: "Data",
                onPressed: () {}
              ),
              const Text(
                "Personalisation",
                style: TextStyle(
                  fontSize: 12.0
                ),
                ),
              Padding(padding: EdgeInsetsGeometry.directional(top: 5)),  
              UIButton(
                icon: Icons.format_paint,
                text: "Themes",
                onPressed: () {}
              ),
              UIButton(
                icon: Icons.language,
                text: "Locales",
                onPressed: () {}
              ),
              const Text(
                "Support",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Padding(padding: EdgeInsetsGeometry.directional(top: 5)),             
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
               Padding(padding: EdgeInsetsGeometry.directional(top: 13)), 
               UIButton(
                icon: Icons.logout,
                text: "Log out",
                onPressed: () async {
                  try {
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  } catch (e) {
                    devtools.log(e.toString());
              }
            }
          )                
        ],
      ),
    );
  }
}