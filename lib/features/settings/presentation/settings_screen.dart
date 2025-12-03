import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/assets.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/features/settings/presentation/widgets/settings_button.dart';
import 'package:flutter_svg/svg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((16.0)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Top row with back button and title
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: SvgPicture.asset(
                        AppAssets.misc.returnIcon,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.settings
                        ,
                        size: 30.0,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Settings",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
        
              // Personal Section
              const Text("Personal", style: TextStyle(fontSize: 12.0)),
              Padding(padding: EdgeInsetsGeometry.directional(top: 5)),
              SettingsUIButton(
                icon: Icons.line_weight,
                text: "Profile",
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    editProfileRoute);
                },
              ),
              SettingsUIButton(
                icon: Icons.pie_chart,
                text: "Data",
                onPressed: () {}),
        
              // Personalisation Section
              const Text("Personalisation", style: TextStyle(fontSize: 12.0)),
              Padding(padding: EdgeInsetsGeometry.directional(top: 5)),
              SettingsUIButton(
                icon: Icons.format_paint,
                text: "Themes",
                onPressed: () {},
              ),
              SettingsUIButton(
                icon: Icons.language,
                text: "Locales",
                onPressed: () {}),
              
              // Support Section
              const Text("Support", style: TextStyle(fontSize: 12.0)),
              Padding(
                padding: EdgeInsetsGeometry.directional(top: 5)),
              SettingsUIButton(
                icon: Icons.info_rounded,
                text: "About",
                onPressed: () {}),
              SettingsUIButton(
                icon: Icons.bug_report,
                text: "Bugs",
                onPressed: () {}),
              SettingsUIButton(
                icon: Icons.support,
                text: "Support",
                onPressed: () {}),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              AppAssets.profile.profileDumbellIcon,
                              width: 100,
                              height: 100,
                          ),
                          const Text('Workout Diary Settings',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      
                      ],
                        ),
                          ),
                            ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 22.0),
                              child: SvgPicture.asset(
                                AppAssets.profile.profileMealIcon,
                                width: 50,
                                height: 50,
                                                        ),
                            ),
                          const Text(
                            'Food Diary\n  Settings',
                            style: TextStyle(
                              fontSize: 16,
                            )
                              ),
                      
                      ],
                      ),
                      
                      ),
                    ),
                ],),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
