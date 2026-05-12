import 'package:flutter/material.dart';
import '../../../../../core/assets.dart' show AppAssets;
import 'package:flutter_svg/svg.dart';

// Data Models
import '../../../data/workout_model.dart' show Exercise, Variation;

// Rect Button Widget
import '../../workout_base.dart' show buildRectButton;

class ExerciseDialogue extends StatefulWidget {
  // final List<Variation> variations;
  // final Exercise exercise;

  const ExerciseDialogue({super.key});

  @override
  State<ExerciseDialogue> createState() => ExerciseDialogueState();
}

class ExerciseDialogueState extends State<ExerciseDialogue> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment(0, -0.5),
      insetPadding: EdgeInsets.all(8),
      child: FractionallySizedBox(
        heightFactor: 0.7,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.primary,
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            spacing: 8,
            children: [
              _buildDialogueHeader(context, 'Create New Exercise'),

              // Scollable body
              Expanded(
                child: SingleChildScrollView(
                  child: Placeholder(),
                ),
              ),
              ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDialogueHeader(BuildContext context, String headerTitle) {
  return Column(
    spacing: 8,
    children: [
      SizedBox(
        height: 50,
        child: Row(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildRectButton(
              iconData: Icon(Icons.close_rounded, size: 28, fontWeight: FontWeight.w600),
              onPressed: () => Navigator.pop(context),
              containerColor: Colors.white,
              borderRadius: 10,
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    headerTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            buildRectButton(
              iconData: Icon(Icons.east_rounded, size: 28, fontWeight: FontWeight.w600),
              onPressed: () => Navigator.pop(context),
              containerColor: Colors.white,
              borderRadius: 10,
            ),
          ],
        ),
      ),
      SizedBox(
        height: 30,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6)
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            spacing: 8,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  'Name: ',
                  style: TextStyle(fontSize: 14)
                ),
              ),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                  autocorrect: false,
                  decoration: InputDecoration(
                    label: Center(
                      child: Text(
                        'Exercise name',
                        style: const TextStyle(fontSize: 12, color: Colors.grey,),
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.only(bottom: 0.5, left: 6),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5,),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5,),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      )
    ]
  );
}

Widget _buildMuscleSelection(BuildContext context){
  return Placeholder();
}