class AppAssets {
  static const workout = _WorkoutAssets();
  static const food = _FoodAssets();
  static const misc = _MiscAssets();
}

class _WorkoutAssets {
  const _WorkoutAssets();
  final String workoutIcon = 'assets/svg/lucide--dumbbell.svg';
}

class _FoodAssets {
  const _FoodAssets();
  final String logFoodIcon = 'assets/svg/mdi--food-apple-outline.svg';
}

class _MiscAssets {
  const _MiscAssets();
  final String progressIcon = 'assets/svg/game-icons--progression.svg';
  final String widgetsIcon = 'assets/svg/bxs-widget.svg';
  final String settingsIcon = 'assets/svg/material-symbols--settings.svg';
  final String plansIcon = 'assets/svg/ri--calendar-schedule-fill.svg';
  final String targetIcon = 'assets/svg/material-symbols--target.svg';
}