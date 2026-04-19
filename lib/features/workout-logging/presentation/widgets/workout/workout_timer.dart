import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Service
import 'workout_services.dart';

// Workout Timer Widget
class WorkoutTimer extends StatelessWidget {
  final Color color;

  const WorkoutTimer({required this.color});

  @override
  Widget build(BuildContext context) {
    final time = context.select<WorkoutService, String>((service) => service.timerService.displayTime);

    return SizedBox(
      width: 60,
      child: Text(
        time,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12, overflow: TextOverflow.ellipsis),
        ),
    );
  }
}