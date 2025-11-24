import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // unused
import 'package:flutter_application_1/core/assets.dart';
import 'package:flutter_svg/svg.dart';

ThemeData getThemeData() {
  return ThemeData(
    primaryColor: Color.fromRGBO(218, 218, 218, 1),
    cardColor: Colors.white,
    fontFamily: 'Inter',

    colorScheme: ColorScheme.light(
      primary: Color.fromRGBO(218, 218, 218, 1),
      secondary: Color.fromRGBO(48, 48, 48, 0.6),
      tertiary: Colors.black,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color containerColor;
  final double borderRadius;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor = Colors.transparent,
    this.containerColor = Colors.white,
    this.borderRadius = 12.0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight - 10);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        color: backgroundColor,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button container
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: containerColor,
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset(
                        AppAssets.misc.returnIcon,
                        width: 18,
                        height: 18,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16,),
              // Title container
              Flexible(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: containerColor,
                  ),
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
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

class CustomBottomAppBar extends StatelessWidget {
  final String module;

  const CustomBottomAppBar({Key? key, required this.module});

  @override
  Widget build(BuildContext context) {
    final moduleSpecific = {
      'workout': {
        'buttons' : ['Calendar', 'Exercises', 'Milestones', 'Settings'],
        'icons' : [
          AppAssets.misc.calendarIcon,
          AppAssets.workout.dumbellIcon,
          AppAssets.workout.trophyIcon,
          AppAssets.misc.settingsIcon,
        ],
        'onPressedActions' : [
          () { debugPrint('Calendar pressed in workout mode'); },
          () { debugPrint('Exercises pressed in workout mode'); },
          () { debugPrint('Milestones pressed in workout mode'); },
          () { debugPrint('Settings pressed in workout mode'); },
        ],
      },
      'food': {
        'buttons' : ['Calendar', 'Meals', 'Scan', 'Settings'],
        'icons' : [
          AppAssets.misc.calendarIcon,
          AppAssets.food.mealsIcon,
          AppAssets.food.scanBarcodeIcon,
          AppAssets.misc.settingsIcon,
        ],
        'onPressedActions' : [
          () { debugPrint('Calendar pressed in food mode'); },
          () { debugPrint('Meals pressed in food mode'); },
          () { debugPrint('Scan pressed in food mode'); },
          () { debugPrint('Settings pressed in food mode'); },
        ],
      }
    };

    // Build buttons dynamically based on module
    final List<String> buttons = List<String>.from(moduleSpecific[module]?['buttons'] ?? []);
    final List<String> icons = List<String>.from(moduleSpecific[module]?['icons'] ?? []);
    final List<Function> actions = List<Function>.from(moduleSpecific[module]?['onPressedActions'] ?? []);

    final buttonWidgets = <Widget>[];
    for (int i = 0; i < buttons.length; i++) {
      buttonWidgets.add(
        _buildRectButton(
          SvgPicture.asset(
            icons[i],
            height: 28,
            width: 28,
          ),
          buttons[i],
          actions[i],
          context
        )
      );

      // Add spacing for FAB notch after second button
      if (i == 1) {
        buttonWidgets.add(const SizedBox(width: 64));
      }
    }

    return BottomAppBar(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      color: Color.fromARGB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...buttonWidgets
        ],
      ),
    );
  }

  Widget _buildRectButton(SvgPicture icon, String label, Function customFunction, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Threshold width at which to hide text
            final bool isCompact = constraints.maxWidth < 65;

            return ElevatedButton(
              onPressed: () {
                customFunction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Enlarge icon when text is hidden
                  SizedBox(
                    height: isCompact ? 36 : 28,
                    width: isCompact ? 36 : 28,
                    child: icon,
                  ),
                  if (!isCompact) ...[
                    Text(
                      label,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Flutters built-in CenterDocked is too high for the current design and there's no other practical way of changing it.
class CustomCenterDockedFABLocation extends FloatingActionButtonLocation {
  final double offsetY;

  const CustomCenterDockedFABLocation(this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2;
    final double fabY = scaffoldGeometry.contentBottom - 
                        (scaffoldGeometry.floatingActionButtonSize.height / 2) - 
                        offsetY;
    return Offset(fabX, fabY);
  }
}