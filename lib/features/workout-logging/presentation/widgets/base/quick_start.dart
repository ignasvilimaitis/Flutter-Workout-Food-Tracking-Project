import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

// Workout Timer
import '../workout/workout_timer.dart';
import '../workout/workout_services.dart';
import '../workout/workout.dart' show startWorkout;

class QuickStart extends StatelessWidget {
  const QuickStart({super.key});

  @override
  Widget build(BuildContext context) {
    late bool activeWorkout = 
      context.select<WorkoutService, bool?>((service) => service.workoutStateService.isWorkoutActive) ?? false;

    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;

    if (activeWorkout) {
      // Re-start workout timer
      context.read<WorkoutService>().timerService.startTimer();

      return Row(
        children: [
          Expanded(
                child: InkWell(
                  onTap: () => startWorkout(context),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              size: 32,
                              color: primaryColor,
                            ),
                            Text(
                              'Continue Workout',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Icon(Icons.timer, color: primaryColor, size: 20,),
                            WorkoutTimer(color: primaryColor)
                          ]
                        )
                      ],
                    ),
                  )
                )
              ),
        ],
      );
    } else {
      return Row(
        spacing: 10,
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
}
