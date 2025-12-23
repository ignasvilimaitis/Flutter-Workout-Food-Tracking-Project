import 'package:flutter/material.dart';

startWorkout(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.black,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.4,
        maxChildSize: 1,
        expand: false,
        builder: (context, scrollController) {
          return EmptyWorkout(scrollController: scrollController,);
        }
      );
    }
  );
}

class EmptyWorkout extends StatelessWidget {
  final ScrollController scrollController;

  const EmptyWorkout({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
    
          // Timer (always visible)
          const Text('Timer'),
    
          // Scrollable workout logger
          Expanded(
            child: ListView(
              controller: scrollController,
              children: const [
                // sets, reps, notes, etc.
              ],
            ),
          ),
        ],
      ),
    );
  }
}