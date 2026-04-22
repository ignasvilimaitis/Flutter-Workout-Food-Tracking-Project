import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Core
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/core/assets.dart';

// Pages
import 'workout_home.dart';
import 'workout_exercises.dart';

// Data Models
import '../data/workout_model.dart' show Variation;

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
  final Widget? thirdRow; // Optional for pages that don’t need it
  final Color backgroundColor;
  final double containerRadius;

  const BaseAppBarSkeleton({
    super.key,
    required this.firstRow,
    this.secondRow,
    this.thirdRow,
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
              if (thirdRow != null) SizedBox(
                height: secondRowHeight,
                child: thirdRow,
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

class CustomAppBarExercisesDetails extends StatelessWidget implements PreferredSizeWidget {
  final Color containerColor;
  final double borderRadius;
  final String exerciseName;
  final List<Variation> variations;
  final Variation selectedVariation;
  final Function(Variation) onVariationChanged;

  const CustomAppBarExercisesDetails({
    super.key,
    this.containerColor = Colors.white,
    this.borderRadius = 12.0,
    required this.exerciseName,
    required this.variations,
    required this.selectedVariation,
    required this.onVariationChanged,
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
            iconData: Icon(Icons.close_rounded, size: 28),
            onPressed: () => Navigator.pop(context),
            containerColor: containerColor,
            borderRadius: borderRadius,
          ),

          // Exercise Name
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: Text(
                  exerciseName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          // Options button
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: containerColor,
              ),
              child: PopupMenuButton<String?>(
                icon: Icon(Icons.more_horiz_rounded, size: 28),
                offset: const Offset(0, 50),
                menuPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                onSelected: (variation) {
                  if (variation == null) {
                    //TODO
                  } else {
                    // Other
                  }
                },
                itemBuilder: (BuildContext context) {
                  final List<Map<String, dynamic>> optionsMap = [
                    {'icon': Icons.file_copy_rounded, 'value': 'copy', 'label': 'Create a copy'},
                    {'icon': Icons.dashboard_customize_rounded, 'value': 'new_variation', 'label': 'New variation'},
                    {'icon': Icons.edit_square, 'value': 'edit', 'label': 'Edit exercise'},
                    {'icon': Icons.delete_rounded, 'value': 'delete', 'label': 'Delete exercise'},
                  ];

                  return <PopupMenuEntry<String?>>[
                    for (final option in optionsMap)
                      PopupMenuItem(
                        value: option['value'],
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Icon(option['icon'], size: 20),
                            ),
                            Expanded(
                              child: Text(
                                option['label'],
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12,),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ];
                }, 
              ),
            ),
          )
        ],
      ),

      // SECOND ROW
      secondRow: Row(
        spacing: 8,
        children: [
          // "Variation" text container
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Center(
                child: Text(
                  'Variation:',
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),

          // Dropdown for variations
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: PopupMenuButton<Variation?>(
                offset: const Offset(0, 35),
                menuPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                onSelected: (variation) {
                  if (variation == null) {
                    //TODO
                  } else {
                    onVariationChanged(variation);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<Variation?>>[
                    for (final variation in variations)
                      PopupMenuItem<Variation?>(
                        value: variation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                variation.name,
                                style: TextStyle(
                                  fontWeight: variation == selectedVariation
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (variation.isDefault) ...[
                              Badge(
                                label: Text(
                                  'Default',
                                  style: TextStyle(fontSize: 8),
                                ),
                                backgroundColor: Colors.grey,
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Add custom row at the end to create a new variation
                      const PopupMenuDivider(indent: 10, endIndent: 10, height: 1,),
                      const PopupMenuItem(
                        value: null,
                        child: Center(
                          child: Text(
                            'Add New +',
                            style: TextStyle(fontSize: 12,),
                          ),
                        ),
                      ),
                  ];
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ 
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          selectedVariation.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 32,
                    )
                  ]
                ),
              ),
            ),
          ),
        ]
      ),

      // THIRD ROW
      thirdRow: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: containerColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TabBar(
            tabs: [
              Tab(child: _buildTab('About', context)),
              Tab(child: _buildTab('History', context)),
              Tab(child: _buildTab('Charts', context)),
              Tab(child: _buildTab('Records', context)),
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
  required dynamic iconData,
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
          icon: iconData is SvgPicture ? iconData : iconData,
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