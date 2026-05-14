import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/workout_model.dart' show VariantMuscle;
import 'package:flutter_application_1/core/assets.dart' show AppAssets;
import 'package:flutter_application_1/core/utils/helpers.dart' show applyColorsToSvg;

/// Creates a widget that displays the muscle anatomy SVG. 
/// 
/// (optional) The widget comes with the ability to flip the view (back or front), as well as the ability to view the diagram full screen (managed via navigator context) 
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

  const MuscleAnatomy({
    super.key,
    this.muscles,
    this.frontView = true,
    this.showFlipButton = true,
    this.tapToFlip = true,
    this.acceptFullscreen = true
  });

  @override
  State<MuscleAnatomy> createState() => _MuscleAnatomyState();
}

class _MuscleAnatomyState extends State<MuscleAnatomy> {
  late bool frontView;
  late String frontSvg;
  late String backSvg;
  late final Future<Map<String, String>> _svgFuture;

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

  @override
  void initState() {
    super.initState();
    frontView = widget.frontView;
    _svgFuture = _loadData().then((svg) {
      frontSvg = svg['front']!;
      backSvg = svg['back']!;

      // Build the color map to apply to the svg based on the muscle roles
      if (widget.muscles?.isNotEmpty == true) {
        for (final muscle in widget.muscles!){
          if (muscle.svgId != null && muscle.color != null){
            idToColor.putIfAbsent(muscle.svgId!, () => muscle.color!);
          }
        }

        frontSvg = applyColorsToSvg(frontSvg, idToColor);
        backSvg = applyColorsToSvg(backSvg, idToColor);
      }

      return svg;
    });
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
                key: ValueKey(frontView),
                onTap: () {
                  if (widget.tapToFlip){
                    setState(() {
                      frontView = !frontView;
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
                  onPressed: () {
                    setState(() {
                      frontView = !frontView;
                    });
                  }, 
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