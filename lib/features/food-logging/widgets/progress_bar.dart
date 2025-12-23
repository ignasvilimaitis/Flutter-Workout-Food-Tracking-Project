import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/data/food_data_source.dart';
import 'package:flutter_application_1/features/food-logging/data/food_repository.dart';
import 'package:flutter_application_1/core/enums.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:provider/provider.dart';

class MacroProgressBar extends StatelessWidget {
  final String macroName;
  final MacroType macroType;
  final Color color;

  const MacroProgressBar({
    super.key,
    required this.macroName,
    required this.macroType,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodViewModel>(
      builder: (context, vm, child) {
        final totals = vm.macroTotals;
        final targets = vm.macroTargets;

        double current = 0;
        double goal = 1; // prevent divide-by-zero

        switch (macroType) {
          case MacroType.energy:
            current = totals['total_calories_consumed'] ?? 0;
            goal = targets['calorie_target'] ?? 1;
            break;

          case MacroType.carbs:
            current = totals['total_carbs_consumed'] ?? 0;
            goal = (targets['calorie_target'] ?? 0) *
                ((targets['carb_percentage'] ?? 0) / 100) /
                4;
            break;

          case MacroType.protein:
            current = totals['total_proteins_consumed'] ?? 0;
            goal = (targets['calorie_target'] ?? 0) *
                ((targets['protein_percentage'] ?? 0) / 100) /
                4;
            break;

          case MacroType.fat:
            current = totals['total_fats_consumed'] ?? 0;
            goal = (targets['calorie_target'] ?? 0) *
                ((targets['fat_percentage'] ?? 0) / 100) /
                9;
            break;
        }

        final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$macroName: ${current.toStringAsFixed(1)}g',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF525252),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(goal - current).toStringAsFixed(1)}g',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF525252),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                borderRadius: BorderRadius.circular(16),
                valueColor: AlwaysStoppedAnimation(color),
                backgroundColor: Colors.grey.shade300,
              ),
            ],
          ),
        );
      },
    );
  }
}



