import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:provider/provider.dart';

enum NutrientType {energy, carbs, protein, fat}

class NutritionProgressBar extends StatefulWidget {
  final String nutrientName;
  final NutrientType nutrientType;
  final FoodItem food;
  const NutritionProgressBar(
    {super.key,
    required this.nutrientType,
    required this.food,
    required this.nutrientName,
    });

  @override
  State<NutritionProgressBar> createState() => _NutritionProgressBarState();
}

class _NutritionProgressBarState extends State<NutritionProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MacroGoal>(
      builder: (context, macroGoals, child) {
        double current;
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
                                text:
                                    '${current.toStringAsFixed(1)}g',
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
                          "${(goal - current).toStringAsFixed(1)}g",
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
                            Colors.blueAccent,
                          ),
                    ),
                  ],
                ),
              );
      }
    );
  }
}