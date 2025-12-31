import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums.dart';
import 'package:flutter_application_1/features/food-logging/presentation/widgets/macro_progress_bar.dart';

class MacroTargetsWidget extends StatelessWidget {
  const MacroTargetsWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 10),
        Text('Targets',
            style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        MacroProgressBar(
          macroName: 'Protein',
          macroType: MacroType.protein,
          color: Colors.green,
        ),
        SizedBox(height: 20),
        MacroProgressBar(
          macroName: 'Carbs',
          macroType: MacroType.carbs,
          color: Colors.blue,
        ),
        SizedBox(height: 20),
        MacroProgressBar(
          macroName: 'Fat',
          macroType: MacroType.fat,
          color: Colors.orange,
        ),
      ],
    );
  }
}