import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Local time
import 'package:flutter_application_1/core/local_time.dart';
import 'package:intl/intl.dart';

// Workout services
import 'workout_timer.dart';
import 'workout_services.dart';


void startWorkout(BuildContext context) {
  final bool? activeWorkout = context.read<WorkoutService>().workoutStateService.isWorkoutActive;
  if (activeWorkout == true){
    // TODO: Show dialog asking if users wants to end existing workout
    //return;
  } else {
    // Update workout state
    context.read<WorkoutService>().workoutStateService.setWorkoutActive(true);
    context.read<WorkoutService>().workoutStateService.setStartTime(DateTime.now());
  }

  context.read<WorkoutService>().timerService.startTimer();
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.black,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.4,
        maxChildSize: 1,
        expand: false,
        builder: (context, scrollController) {
          return EmptyWorkout(scrollController: scrollController,);
        }
      );
    }
  );
}


void endWorkout(BuildContext context) {
  // Update relevant state
  // TODO: Show confirmation dialog before canceling workout
  context.read<WorkoutService>().workoutStateService.setWorkoutActive(false);
  context.read<WorkoutService>().workoutStateService.removeStartTime();
  context.read<WorkoutService>().timerService.stopTimer();
}

class EmptyWorkout extends StatefulWidget {
  final ScrollController scrollController;

  const EmptyWorkout({super.key, required this.scrollController});

  @override
  State<EmptyWorkout> createState() => _EmptyWorkoutState();
}

class _EmptyWorkoutState extends State<EmptyWorkout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        
            // Header
            _buildHeader(context),

            // Sub-header
            _buildSubHeader(context),
        
            // Scrollable workout logger
            Expanded(
              child: ListView(
                controller: widget.scrollController,
                children: [
                  // sets, reps, notes, etc.

                  // Add exercise and cancel workout buttons at the end
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add exercise logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add Exercise',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      endWorkout(context);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel Workout',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.timer, color: Colors.black,),
              )
            )
          ),
          Flexible(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('Upper', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              )
            )
          ),
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.more_horiz, color: Colors.black,),
              )
            )
          ),
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.save, color: Colors.black,),
              )
            )
          )
        ],
      ),
    );
  }
  Widget _buildSubHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        height: 30,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Icon(Icons.calendar_month, color: Colors.grey, size: 16,),
                    Text(
                      LocalTime().formatOrdinalLong(DateTime.parse(context.read<WorkoutService>().workoutStateService.startTime!)),
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                    )
                  ]
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Icon(Icons.access_time, color: Colors.grey, size: 16,),
                    Text(
                      DateFormat('hh:mm').format(DateTime.parse(context.read<WorkoutService>().workoutStateService.startTime!)),
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                    )
                  ]
                ),
              ),
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Flexible(flex: 1, child: Icon(Icons.timer, color: Colors.grey, size: 16,)),
                    Flexible(flex: 1,child: WorkoutTimer(color: Colors.grey,)),
                  ]
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}