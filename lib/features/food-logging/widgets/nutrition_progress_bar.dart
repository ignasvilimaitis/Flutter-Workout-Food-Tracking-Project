import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums.dart';
import 'package:flutter_application_1/features/food-logging/classes/food_item.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

class NutritionProgressBar extends StatefulWidget {
  final String nutrientName;
  final NutrientType nutrientType;
  final FoodItem food;
  final Color widgetColor;

  const NutritionProgressBar(
    {super.key,
    required this.nutrientType,
    required this.food,
    required this.nutrientName,
    required this.widgetColor,
    });

  @override
  State<NutritionProgressBar> createState() => _NutritionProgressBarState();
}

class _NutritionProgressBarState extends State<NutritionProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MacroGoal>(
      builder: (context, macroGoals, child) {
        double? current;
        double goal;
        switch (widget.nutrientType) {
          case NutrientType.energy:
          current = widget.food.calories;
          goal = macroGoals.calorieGoal;
          case NutrientType.carbs:
          current = widget.food.carbs;
          goal = macroGoals.carbGoal;
          break;
          case NutrientType.protein:
          current = widget.food.proteins;
          goal = macroGoals.proteinGoal;
          break;
          case NutrientType.fat:
          current = widget.food.fats;
          goal = macroGoals.fatGoal;
          break;
          case NutrientType.salt:
          current = widget.food.nutriments?.getValue(Nutrient.salt, PerSize.serving) ?? 0.0;
          goal = macroGoals.saltGoal;
        }
      return Container(
                width:
                    MediaQuery.of(context).size.width *
                    0.85,
                height: 30,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${widget.nutrientName}: ',
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(
                                        255,
                                        82,
                                        82,
                                        82,
                                      ),
                                  fontWeight:
                                      FontWeight.w900,
                                  fontSize: 12.0,
                                ),
                              ),
                              TextSpan(
                                text: widget.nutrientType == NutrientType.energy ? '${current?.toStringAsFixed(1)}Kcal' : '${current?.toStringAsFixed(1)}g',
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(
                                        255,
                                        82,
                                        82,
                                        82,
                                      ),
                                  fontWeight:
                                      FontWeight.w100,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Text(
                          widget.nutrientType == NutrientType.energy ?  "${(goal).toStringAsFixed(1)}Kcal" : "${(goal).toStringAsFixed(1)}g",
                          style: TextStyle(
                            color: const Color.fromARGB(
                              255,
                              82,
                              82,
                              82,
                            ),
                            fontWeight: FontWeight.w100,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(16.0),
                      value:
                          current /
                          goal,
                      minHeight: 10,
                      color: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                            widget.widgetColor,
                          ),
                    ),
                  ],
                ),
              );
      }
    );
  }
}