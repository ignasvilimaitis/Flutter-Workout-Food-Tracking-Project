import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Core
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/core/assets.dart';

// Pages
import 'workout_home.dart';
import 'workout_exercises.dart';

class BaseLayout extends StatefulWidget {
  final String initialPage;

  const BaseLayout({Key? key, this.initialPage = 'home'}) : super(key: key);

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  late String currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: SizedBox(
        width: 68,
        height: 68,
        child: FloatingActionButton(
          onPressed: () {},
          shape: CircleBorder(),
          backgroundColor: Colors.black,
          child: SvgPicture.asset(
            AppAssets.misc.plusIcon,
            height: 64,
            width: 64,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
      floatingActionButtonLocation: CustomCenterDockedFABLocation(-15),
      bottomNavigationBar: CustomBottomAppBar(
        module: 'workout',
        onPageChanged: (page) {
          setState(() => currentPage = page);
        },
      ),
      body: _buildPage(currentPage),
    );
  }

  Widget _buildPage(String page) {
    void returnHome () {
      setState(() => currentPage = 'home');
    };

    switch (page) {
      case 'calendar':
        return WorkoutHomePage();
      case 'exercises':
        return WorkoutExercisesPage(
          returnHome: returnHome,
        );
      case 'targets':
        return WorkoutHomePage();
      case 'settings':
        return WorkoutHomePage();
      default:
        return WorkoutHomePage();
    }
  }
}

// Create a base app bar skeleton to be reused across different pages.
class BaseAppBarSkeleton extends StatelessWidget implements PreferredSizeWidget {
  final Widget firstRow;
  final Widget? secondRow; // Optional for pages that don’t need it
  final Color backgroundColor;
  final double containerRadius;

  const BaseAppBarSkeleton({
    super.key,
    required this.firstRow,
    this.secondRow,
    this.backgroundColor = Colors.transparent,
    this.containerRadius = 12.0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final double firstRowHeight = kToolbarHeight - 10;
    final double secondRowHeight = secondRow != null ? (firstRowHeight / 1.5) : 0;

    return Padding(
      padding: const EdgeInsets.only(top: 10), // Top padding to separate from status bar
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          color: backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              SizedBox(
                height: firstRowHeight,
                child: firstRow,
              ),
              if (secondRow != null) SizedBox(
                height: secondRowHeight,
                child: secondRow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom AppBar for Home Page
class CustomAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color containerColor;
  final double borderRadius;

  const CustomAppBarHome({
    super.key,
    required this.title,
    this.containerColor = Colors.white,
    this.borderRadius = 12.0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BaseAppBarSkeleton(
      firstRow: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          _buildRectButton(
            iconData: SvgPicture.asset(AppAssets.misc.returnIcon, width: 18, height: 18),
            onPressed: () => Navigator.pop(context),
            containerColor: containerColor,
            borderRadius: borderRadius,
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom AppBar for Exercises Page
class CustomAppBarExercises extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? returnHome;
  final Color containerColor;
  final double borderRadius;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  const CustomAppBarExercises({
    super.key,
    this.returnHome,
    this.containerColor = Colors.white,
    this.borderRadius = 12.0,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 100);

  @override
  Widget build(BuildContext context) {
    return BaseAppBarSkeleton(
      firstRow: Row(
        spacing: 8,
        children: [
          // Back button
          _buildRectButton(
            iconData: SvgPicture.asset(AppAssets.misc.returnIcon, width: 18, height: 18),
            onPressed: () => returnHome?.call(),
            containerColor: containerColor,
            borderRadius: borderRadius,
          ),

          // Search bar
          Expanded(
            flex: 5,
            child: _buildSearchContainer(
              context: context,
              containerColor: containerColor,
              borderRadius: borderRadius,
              searchController: searchController,
              onSearchChanged: onSearchChanged,
            ),
          ),

          // Plus button
          _buildRectButton(
            iconData: SvgPicture.asset(AppAssets.misc.plusIcon, width: 48, height: 48),
            onPressed: () => Navigator.pop(context),
            containerColor: containerColor,
            borderRadius: borderRadius,
          ),
        ],
      ),

      // SECOND ROW
      secondRow: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: containerColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TabBar(
            tabs: [
              Tab(child: _buildTab('All', context)),
              Tab(child: _buildTab('Favourites', context)),
              Tab(child: _buildTab('Custom', context)),
            ],
            dividerHeight: 0,
            labelStyle: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            indicator: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

Widget _buildTab(String label, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black),
      ),
    ),
  );
}

Widget _buildRectButton({
  required SvgPicture iconData,
  required VoidCallback onPressed,
  required Color containerColor,
  required double borderRadius,
}) {
  return Flexible(
    flex: 1,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: containerColor,
      ),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: iconData,
        ),
      ),
    ),
  );
}

Widget _buildSearchContainer({
  required BuildContext context,
  required Color containerColor,
  required double borderRadius,
  required TextEditingController searchController,
  required Function(String) onSearchChanged, //Callback for search
}) { 
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: containerColor,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        spacing: 4,
        children: [
          SvgPicture.asset(AppAssets.misc.searchIcon, width: 24, height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  labelText: 'Search all exercises...',
                  labelStyle: const TextStyle(fontSize: 12, color: Colors.grey,),
                  contentPadding: const EdgeInsets.only(bottom: 0.5, left: 6),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.5,),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.5,),
                  ),
                ),
              ),
            ),
          ),
          SvgPicture.asset(AppAssets.misc.filterIcon, width: 24, height: 24),
        ],
      ),
    ),
  );
}