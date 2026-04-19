import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/core/assets.dart';

import 'package:flutter_application_1/core/local_time.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final String greeting = 'Good ${getTimePeriod()}!';
  final String currentDate = LocalTime().todayWithMonth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              createHeader(greeting, currentDate, context),
              const SizedBox(height: 10), // Spacer
              createMain(context),
              const SizedBox(height: 10), // Spacer
              createFooter(context)
            ],
          ),
        ),
      ),
    );
  }
}

Card createHeader(String greeting, String currentDate, context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(greeting, style: TextStyle(fontSize: 18)),
                Text(
                  currentDate,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'IstokWeb',
                    fontWeight: FontWeight.w100,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    // Navigate to workout screen
                    Navigator.pushNamed(context, workoutHomeRoute);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.workout.workoutIcon,
                        height: 32,
                        width: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start Workout',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    // Navigate to log food screen
                    // On click load the saved state from food logging
                    Navigator.of(context).pushNamed(foodLoggingRoute);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.food.logFoodIcon,
                        height: 32,
                        width: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Log Food',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Expanded createMain(context) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.misc.targetIcon,
                    height: 32,
                    width: 32,
                  ),
                  Text(
                    "Today's Progress:",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /* 
            TODO: At some point to create a custom widget or function that allows dynamic population of these widgets.
            Currently just set to empty buttons in a 2x3 area for prototyping
            */

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Navigate to workout screen
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [SizedBox(height: 110)],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Navigate to workout screen
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [SizedBox(height: 110)],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Navigate to workout screen
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [SizedBox(height: 110)],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Navigate to workout screen
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [SizedBox(height: 110)],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Navigate to workout screen
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [SizedBox(height: 110)],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      // Navigate to workout screen
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [SizedBox(height: 110)],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Row createFooter(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
              backgroundColor: Theme.of(context).cardColor,
            ),
            onPressed: () {
              // TODO: Navigate to workout screen
            },
            child: Column(
              children: [
                Text(
                  'Test',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
              backgroundColor: Theme.of(context).cardColor,
            ),
            onPressed: () {
              // TODO: Navigate to workout screen
            },
            child: Column(
              children: [
                Text(
                  'Test',
                  style: TextStyle(
                    color: Colors.black,
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
      Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
              backgroundColor: Theme.of(context).cardColor,
            ),
            onPressed: () {
              // TODO: Navigate to workout screen
            },
            child: Column(
              children: [
                Text(
                  'Test',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
              backgroundColor: Theme.of(context).cardColor,
            ),
            onPressed: () {
              // TODO: Navigate to workout screen
            },
            child: Column(
              children: [
                Text(
                  'Test',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}


// Helpers

String getTimePeriod({String? period}) {
  int hour;
  if (period == null) {
    hour = DateTime.now().hour;
  } else {
    hour = DateTime.parse(period).hour;
  }

  if (hour >= 5 && hour < 12) return 'Morning';
  if (hour >= 12 && hour < 17) return 'Afternoon';
  return 'Evening';
}