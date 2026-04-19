import 'package:flutter/material.dart';

// Shared Preferences
import 'package:flutter_application_1/core/services/preferences_service.dart';

// Async timer
import 'dart:async';

// Single workout service class to combine all workout related services
class WorkoutService extends ChangeNotifier {
  late final WorkoutTimerService timerService;
  late final WorkoutStateService workoutStateService;

  WorkoutService() {
    timerService = WorkoutTimerService();
    workoutStateService = WorkoutStateService();

    timerService.addListener(notifyListeners);
    workoutStateService.addListener(notifyListeners);
  }

  @override
  void dispose() {
    timerService.dispose();
    workoutStateService.dispose();
    super.dispose();
  }
}

// Workout timer service
class WorkoutTimerService extends ChangeNotifier {
  final DateTime currentTime = DateTime.now();
  late DateTime workoutStartTime = DateTime.parse(PreferencesService().prefs.getString('workout_start_time')!);
  late String displayTime = _formatDuration(currentTime.difference(workoutStartTime));
  late Timer _timer;

  bool isRunning = false;

  void startTimer() {
    if (isRunning) return;
    isRunning = true;

    // Re-read start time if timer is restarted
    workoutStartTime = DateTime.parse(PreferencesService().prefs.getString('workout_start_time')!);

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final elapsed = DateTime.now().difference(workoutStartTime);
      displayTime = _formatDuration(elapsed);
      notifyListeners();
    });
  }

  void stopTimer() {
    isRunning = false;
    _timer.cancel();
    displayTime = '00:00:00';
    notifyListeners();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}

// Workout state management
class WorkoutStateService extends ChangeNotifier {
  bool? get isWorkoutActive => PreferencesService().prefs.getBool('active_workout');
  String? get startTime => PreferencesService().prefs.getString('workout_start_time');

  void setWorkoutActive(bool value) {
    PreferencesService().prefs.setBool('active_workout', value);
    notifyListeners();
  }

  void setStartTime(DateTime time) {
    PreferencesService().prefs.setString('workout_start_time', time.toIso8601String());
    notifyListeners();
  }

  void removeStartTime() {
    PreferencesService().prefs.remove('workout_start_time');
    notifyListeners();
  }
}