import 'package:flutter/material.dart';

enum SlideDirection { left, right }

class SlidingPageSwitcher extends StatelessWidget {
  final Widget child;
  final Key pageKey;
  final SlideDirection direction;
  final Duration duration;

  const SlidingPageSwitcher({
    super.key,
    required this.child,
    required this.pageKey,
    required this.direction,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final beginOffset =
            direction == SlideDirection.left
                ? const Offset(-1.0, 0.0)
                : const Offset(1.0, 0.0);

        final slideAnimation = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
      child: KeyedSubtree(
        key: pageKey,
        child: child,
      ),
    );
  }
}
