class AppAssets {
  static const workout = _WorkoutAssets();
  static const food = _FoodAssets();
  static const misc = _MiscAssets();
  static const logging = _LoggingAssets();
}

class _WorkoutAssets {
  const _WorkoutAssets();
  final String workoutIcon = 'assets/svg/lucide--dumbbell.svg';
  final String trophyIcon = 'assets/svg/material-symbols--trophy-outline.svg';
  final String dumbellIcon = 'assets/svg/streamline-plump--dumbell-solid.svg';
}

class _FoodAssets {
  const _FoodAssets();
  final String logFoodIcon = 'assets/svg/mdi--food-apple-outline.svg';
  final String scanBarcodeIcon = 'assets/svg/material-symbols--barcode.svg';
  final String mealsIcon = 'assets/svg/emojione-monotone--fork-and-knife-with-plate.svg';
}

class _MiscAssets {
  const _MiscAssets();
  final String progressIcon = 'assets/svg/game-icons--progression.svg';
  final String widgetsIcon = 'assets/svg/bxs-widget.svg';
  final String settingsIcon = 'assets/svg/material-symbols--settings.svg';
  final String plansIcon = 'assets/svg/ri--calendar-schedule-fill.svg';
  final String targetIcon = 'assets/svg/material-symbols--target.svg';
  final String returnIcon = 'assets/svg/streamline--return-2-solid.svg';
  final String plusIcon = 'assets/svg/ic--round-plus.svg';
  final String calendarIcon = 'assets/svg/mdi--calendar.svg';
  final String filterIcon = 'assets/svg/mdi--filter.svg';
  final String searchIcon = 'assets/svg/entypo--magnifying-glass.svg';
}

class _LoggingAssets {
  const _LoggingAssets();
  final String missingFoodIcon = 'assets/svg/food--not--found.svg';
}