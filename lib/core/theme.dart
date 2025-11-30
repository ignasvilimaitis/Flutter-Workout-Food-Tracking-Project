import 'package:flutter/material.dart';
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

class CustomBottomAppBar extends StatelessWidget {
  final String module;
  final Function(String)? onPageChanged;

  const CustomBottomAppBar({
    Key? key,
    required this.module,
    this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moduleSpecific = {
      'workout': {
        'buttons': ['Calendar', 'Exercises', 'Targets', 'Settings'],
        'pages': ['calendar', 'exercises', 'targets', 'settings'],
        'icons': [
          AppAssets.misc.calendarIcon,
          AppAssets.workout.dumbellIcon,
          AppAssets.workout.trophyIcon,
          AppAssets.misc.settingsIcon,
        ],
      },
      'food': {
        'buttons': ['Calendar', 'Meals', 'Scan', 'Settings'],
        'pages': ['calendar', 'meals', 'scan', 'settings'],
        'icons': [
          AppAssets.misc.calendarIcon,
          AppAssets.food.mealsIcon,
          AppAssets.food.scanBarcodeIcon,
          AppAssets.misc.settingsIcon,
        ],
      }
    };

    final List<String> buttons =
        List<String>.from(moduleSpecific[module]?['buttons'] ?? []);
    final List<String> pages =
        List<String>.from(moduleSpecific[module]?['pages'] ?? []);
    final List<String> icons =
        List<String>.from(moduleSpecific[module]?['icons'] ?? []);

    final buttonWidgets = <Widget>[];

    for (int i = 0; i < buttons.length; i++) {
      buttonWidgets.add(
        _buildRectButton(
          iconPath: icons[i],
          label: buttons[i],
          onPressed: () {
            onPageChanged?.call(pages[i]);
            }
        ),
      );

      // Add spacing for FAB notch after second button
      if (i == 1) {
        buttonWidgets.add(const SizedBox(width: 64));
      }
    }

    return BottomAppBar(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 6,
        children: buttonWidgets,
      )
    );
  }

  Widget _buildRectButton({
    required String iconPath,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isCompact = constraints.maxWidth < 55;

          return ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  iconPath,
                  height: isCompact ? 32 : 24,
                  width: isCompact ? 32 : 24,
                ),
                if (!isCompact)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          );
        },
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