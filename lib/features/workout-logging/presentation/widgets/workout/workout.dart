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

class EmptyWorkout extends StatefulWidget {
  final ScrollController scrollController;

  const EmptyWorkout({super.key, required this.scrollController});

  @override
  State<EmptyWorkout> createState() => _EmptyWorkoutState();
}

class _EmptyWorkoutState extends State<EmptyWorkout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        
            // Header
            _buildHeader(context),
        
            // Scrollable workout logger
            Expanded(
              child: ListView(
                controller: widget.scrollController,
                children: const [
                  // sets, reps, notes, etc.
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.timer, color: Colors.black,),
              )
            )
          ),
          Flexible(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text('Upper', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              )
            )
          ),
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.more_horiz, color: Colors.black,),
              )
            )
          ),
          Flexible(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(Icons.save, color: Colors.black,),
              )
            )
          )
        ],
      ),
    );
  }
}