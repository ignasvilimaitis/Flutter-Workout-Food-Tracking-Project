import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:provider/provider.dart';

enum MacroType {carbs, protein, fat}

class MacroProgressBar extends StatefulWidget {
  final String macroName;
  final MacroType macroType;
  final Color color;

  const MacroProgressBar(
    {super.key,
    required this.macroName,
    required this.macroType,
    required this.color,
    });

  @override
  State<MacroProgressBar> createState() => _MacroProgressBarState();
}

class _MacroProgressBarState extends State<MacroProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<TotalMacros, MacroGoal>(
      builder: (context, totalMacros, macroGoals, child) {
        double current;
        double goal;
        switch (widget.macroType) {
          case MacroType.carbs:
          current = totalMacros.carbAmount;
          goal = macroGoals.carbGoal;
          break;
          case MacroType.protein:
          current = totalMacros.proteinAmount;
          goal = macroGoals.proteinGoal;
          break;
          case MacroType.fat:
          current = totalMacros.proteinAmount;
          goal = macroGoals.proteinGoal;
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
                                text: '${widget.macroName}: ',
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
                            widget.color,
                          ),
                    ),
                  ],
                ),
              );
      }
    );
}
}