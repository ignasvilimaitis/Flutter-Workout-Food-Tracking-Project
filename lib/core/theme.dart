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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // Back button container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                AppAssets.misc.returnIcon,
                width: 18,
                height: 18,
              ),
            )
          ),
          const SizedBox(width: 8),
          // Title container
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomAppBar extends StatelessWidget {
  final String module;

  const CustomBottomAppBar({
    Key? key,
    required this.module,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example of module-based customization:
    // (You can expand this to change icons, colors, or button behavior)
    final bool isAdmin = module.toLowerCase() == 'admin';

    return BottomAppBar(
      color: Color.fromARGB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRectButton(Icons.home, 'Home', isAdmin),
          _buildRectButton(Icons.search, 'Search', isAdmin),
          _buildCenterCircleButton(context),
          _buildRectButton(Icons.notifications, 'Alerts', isAdmin),
          _buildRectButton(Icons.person, 'Profile', isAdmin),
        ],
      ),
    );
  }

  /// Rectangular button with rounded edges
  Widget _buildRectButton(IconData icon, String label, bool isAdmin) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            // Example of module-specific action
            debugPrint('$label pressed in $module mode');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isAdmin ? Colors.redAccent : Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  /// Central circular elevated button (offset upward)
  Widget _buildCenterCircleButton(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20), // Y-axis offset (lifted)
      child: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        elevation: 6,
        onPressed: () {
          debugPrint('Center button pressed in $module mode');
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}