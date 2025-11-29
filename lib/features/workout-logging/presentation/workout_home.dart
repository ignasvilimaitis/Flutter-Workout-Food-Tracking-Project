import 'package:flutter/material.dart';

// Widgets
import 'package:flutter_application_1/features/workout-logging/presentation/widgets/quick_start.dart';
import 'package:flutter_application_1/features/workout-logging/presentation/widgets/dashboard.dart';
import 'workout_base.dart' show CustomAppBarHome;

class WorkoutHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBarHome(
        title: 'Workout Diary',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Start Section
              Text(
                'Quick Start',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                )
              ),
              QuickStart(),

              // Dashboard Section
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Dashboard(),
                    ]
                  ),
                ),
              ),

              // Current Routine Section
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Routine',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Dashboard(),
                    ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

