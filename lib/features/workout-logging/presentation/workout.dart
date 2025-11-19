import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/assets.dart';
import 'package:flutter_application_1/core/theme.dart';

// Widgets
import 'package:flutter_application_1/features/workout-logging/presentation/widgets/quick_start.dart';
import 'package:flutter_application_1/features/workout-logging/presentation/widgets/dashboard.dart';
import 'package:flutter_svg/svg.dart';

class WorkoutHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBar(
        title: 'Workout Diary',
      ),
      floatingActionButton: SizedBox(
        width: 68, // custom width
        height: 68, // custom height
        child: FloatingActionButton(
          onPressed: () {},
          shape: CircleBorder(),
          backgroundColor: Colors.black,
          child: SvgPicture.asset(
            AppAssets.misc.plusIcon,
            height: 64,
            width: 64,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
      floatingActionButtonLocation: CustomCenterDockedFABLocation(-15),
      bottomNavigationBar: CustomBottomAppBar(module: 'workout'),
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