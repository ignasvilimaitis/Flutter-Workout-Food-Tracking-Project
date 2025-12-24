import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/assets.dart';
import 'package:flutter_svg/svg.dart';

import '../workout/workout.dart' show startWorkout;

class QuickStart extends StatefulWidget {
  const QuickStart({super.key});

  @override
  State<QuickStart> createState() => _QuickStartState();
}

class _QuickStartState extends State<QuickStart> {

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => startWorkout(context),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.misc.plusIcon,
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                  ),
                  Flexible(
                    child: Text(
                      'Empty Workout',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            )
          )
        ),
        SizedBox(width: 20,),
        Expanded(
          child: InkWell(
            onTap:() => print('Routine Workout'),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.misc.plusIcon,
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                  ),
                  Flexible(
                    child: Text(
                      'Routine Workout',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            )
          )
        ),
      ],
    );
  }
}
