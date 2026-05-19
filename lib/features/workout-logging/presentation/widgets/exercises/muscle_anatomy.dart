import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../data/workout_model.dart' show VariantMuscle, VariantMuscleList;
import 'package:flutter_application_1/core/assets.dart' show AppAssets;
import 'package:flutter_application_1/core/utils/helpers.dart' show applyColorsToSvg;

/// Create a controller to access [openDialogue] externally
class MuscleAnatomyController {
  _MuscleAnatomyState? _state;
  void _attach(_MuscleAnatomyState state) => _state = state;
  void _detach() => _state = null;

  Future<void> openDialogue(bool showFooter, {int page = 0}) {
    return _state?.openDialogue(showFooter, page: page) ?? Future.value();
  }
}

class MuscleAnatomy extends StatefulWidget {
  /// A list of [VariantMuscle] model instances to attach to the widget.
  /// 
  /// The widget uses: 
  /// - [VariantMuscle.svgId] to find the relevant path or group to interact with.
  /// - [VariantMuscle.color] a HEX color used to highlight the relevant SVG elements.
  final List<VariantMuscle>? muscles;

  /// Defaulting to the front view of the SVG. The default value is True.
  final bool frontView;

  /// Allows the ability to flip the SVG between the front view and the back view. The default value is True.
  final bool showFlipButton;

  /// A gesture detector that allows tapping anywhere on the SVG to cause it to flip. The default value is True.
  final bool tapToFlip; // TODO: At some point worth adding one-time tooltips to hint that tapping the diagram can flip it.

  /// Allows the ability to view the SVG via a fullscreen dialog managed by the navigator context.
  /// This (ideally) continues to maintain the same amount of interactivity (if any) as not being fullscreen. The default value is True.
  final bool acceptFullscreen;

  /// Use a controller to expose private state methods.
  final MuscleAnatomyController? controller;

  /// Creates a widget that displays the muscle anatomy SVG. 
  /// 
  /// (optional) The widget comes with the ability to flip the view (back or front), as well as the ability to view the diagram full screen (managed via navigator context) 
  const MuscleAnatomy({
    super.key,
    this.muscles,
    this.frontView = true,
    this.showFlipButton = true,
    this.tapToFlip = true,
    this.acceptFullscreen = true,
    this.controller
  });

  @override
  State<MuscleAnatomy> createState() => _MuscleAnatomyState();
}

class _MuscleAnatomyState extends State<MuscleAnatomy> {
  late bool frontView;
  late String originalFrontSvg;
  late String originalBackSvg;
  late String frontSvg;
  late String backSvg;
  late final Future<Map<String, String>> _svgFuture;
  
  /// An interesting fix for the [AnimatedSwitcher] key, using a [bool] causes there to be deadzone moments between switches as it can only be "true" or "false"
  /// with no inbetween, so spamming the switcher would cause an exception. Using an incrementing int fixes that as spamming just increments the int.
  int _flipCounter = 0;

  /// A color map based on [muscles] to be used to highlight the muscles accordingly.
  /// Example:
  /// ```{'triceps-brachii-long-head': '#FFF'}```
  late Map<String, String> idToColor = {};

  // TODO: Explore potentially caching this on first run? Tiny files but constant I/O on every build causes visible frame drops.
  Future<Map<String, String>> _loadData() async {
    final String frontSvgString = await rootBundle.loadString(AppAssets.workout.musclesFront);
    final String backSvgString = await rootBundle.loadString(AppAssets.workout.musclesBack);

    return {
      'front': frontSvgString,
      'back': backSvgString
    };
  }

  void _buildColorMap() {
    idToColor.clear();
    if (widget.muscles?.isNotEmpty == true) {
      for (final muscle in widget.muscles!) {
        if (muscle.svgId != null && muscle.color != null) {
          idToColor.putIfAbsent(muscle.svgId!, () => muscle.color!);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);

    frontView = widget.frontView;
    _svgFuture = _loadData().then((svg) {
      originalFrontSvg = svg['front']!;
      originalBackSvg = svg['back']!;
      frontSvg = svg['front']!;
      backSvg = svg['back']!;

      _buildColorMap();

      frontSvg = applyColorsToSvg(frontSvg, idToColor);
      backSvg = applyColorsToSvg(backSvg, idToColor);

      return svg;
    });
  }
  @override
  void dispose() {
    widget.controller?._detach();
    super.dispose();
  }

  @override
  void didUpdateWidget(MuscleAnatomy oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.muscles != widget.muscles) {
      widget.controller?._attach(this);
      _buildColorMap();

      frontSvg = applyColorsToSvg(originalFrontSvg, idToColor);
      backSvg = applyColorsToSvg(originalBackSvg, idToColor);
      setState(() {});
    }
  }

  /// Opens the full screen anatomy dialogue. Accepts [page] as a parameter to set the initial page view.
  Future<void> openDialogue(bool showMuscleFooter, {int page = 0}) async {
    final dialogueStateKey = GlobalKey<_MuscleAnatomyState>();
    final bool? flipped = await showDialog<bool>(
      context: context, 
      builder: (BuildContext context) => AnatomyDialogue(
        instance: MuscleAnatomy(
            key: dialogueStateKey,
            muscles: widget.muscles,
            acceptFullscreen: false,
            frontView: frontView,
            showFlipButton: widget.showFlipButton,
            tapToFlip: widget.tapToFlip,
          ),
        showMuscleFooter: showMuscleFooter,
        initialPage: page,
        stateKey: dialogueStateKey,
      ),
    );

    if (flipped != null) {
      setState(() => frontView = flipped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>( //Use futurebuilder to smoothen out the loading exercise detail load process
      future: _svgFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading muscle anatomy SVG element. Ensure it is not missing.'));
        }
        if (!snapshot.hasData) {
          return Center(child: Text('SVG element is missing data. Ensure it is not corrupt.'));
        }

        return Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.bounceInOut,
              switchOutCurve: Curves.bounceInOut,
              child: GestureDetector(
                key: ValueKey(_flipCounter),
                onTap: () {
                  if (widget.tapToFlip){
                    setState(() {
                      frontView = !frontView;
                      _flipCounter++;
                    });
                  }
                },
                child: SizedBox.expand(
                  child: SvgPicture.string(
                    frontView ? frontSvg : backSvg,
                  ),
                ),
              ),
            ),

            if (widget.showFlipButton)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      frontView = !frontView;
                    });
                  },
                  icon: Icon(
                    Icons.loop_rounded,
                    color: Colors.grey,
                    )
                )
              ),

            if (widget.acceptFullscreen)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => openDialogue(true), 
                  icon: Icon(
                    Icons.open_in_full_rounded,
                    color: Colors.grey,
                    )
                )
            ),
          ]
        );
      }
    );
  }
}

class AnatomyDialogue extends StatefulWidget {
  final MuscleAnatomy instance;
  final bool showMuscleFooter;
  final int initialPage;
  final GlobalKey<_MuscleAnatomyState> stateKey;
  
  /// [initialPage] is used to point to a specific page in the full screen view. It assumes that the muscles order is ordered by the sequence (i.e., secondary is ALWAYS sequence 2)
  const AnatomyDialogue({
    super.key, 
    required this.instance,
    this.showMuscleFooter = true,
    this.initialPage = 0, 
    required this.stateKey
  });

  @override
  State<AnatomyDialogue> createState() => _AnatomyDialogueState();
}

class _AnatomyDialogueState extends State<AnatomyDialogue> {
  late PageController _pageController;
  late Map<String, List<VariantMuscle>> musclesByRole;

  @override
  void initState() {
    super.initState();
    if (widget.showMuscleFooter) {
      _pageController = PageController(initialPage: widget.initialPage);
    }

    if (widget.instance.muscles != null && widget.showMuscleFooter) {
      musclesByRole = widget.instance.muscles?.groupedByRole as Map<String, List<VariantMuscle>>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(12),
      child: Column(
        spacing: 4,
        children: [
          Flexible(
            flex: 4,
            child: Stack(
              children: [ 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: widget.instance,
                ),
            
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context, widget.stateKey.currentState?.frontView),
                      icon: Icon(
                        Icons.close_rounded, 
                        size: 28, 
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
          if (widget.showMuscleFooter && musclesByRole.isNotEmpty)
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  spacing: 4,
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return PageView(
                            controller: _pageController,
                            children: [
                              for (final role in musclesByRole.entries)
                                _buildFooterRow(role.value, role.key, context, constraints)
                            ],
                          );
                        }
                      )
                    ),
                    SmoothPageIndicator(
                      controller: _pageController, 
                      count: musclesByRole.length,
                      effect: const WormEffect(
                        dotHeight: 10,
                        dotWidth: 10
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Dynamically builds the cards based on the length of [muscles] list.
  Widget _buildFooterRow(List<VariantMuscle> muscles, String role, BuildContext context, BoxConstraints constraints) {
    final cardColor = Color(int.parse("0xFF${muscles.first.color!.replaceAll('#', '')}")).withAlpha(128);

    const double headerHeight = 20;
    const double textHeight = 17;
    final double maxHeight = constraints.maxHeight;

    final int maximumBucketItems = ((maxHeight - headerHeight) / textHeight).floor();
    final List<List<VariantMuscle>> buckets = [];

    for (int i = 0; i < muscles.length; i += maximumBucketItems) {
      buckets.add(muscles.skip(i).take(maximumBucketItems).toList());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: cardColor,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Row(
              children: [
                for (final bucket in buckets)
                  Expanded(
                    child: Column(
                      children: [
                        for (final muscle in bucket)
                          Text(
                            muscle.name!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}