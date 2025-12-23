import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/data/food_data_source.dart';
import 'package:flutter_application_1/features/food-logging/data/food_repository.dart';
import 'package:flutter_application_1/core/enums.dart';

class MacroProgressBar extends StatefulWidget {
  final String macroName;
  final MacroType macroType;
  final Color color;
  final String date;

  const MacroProgressBar(
    {super.key,
    required this.macroName,
    required this.macroType,
    required this.color,
    required this.date
    });

  @override
  State<MacroProgressBar> createState() => _MacroProgressBarState();
}

class _MacroProgressBarState extends State<MacroProgressBar> {
  FoodRepository foodRepo = FoodRepository(FoodDataSource());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([foodRepo.returnMacroTotals(widget.date),
       foodRepo.getMacroTargets(widget.date)]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Loading...');
        } else{
          double current = 0.0;
          double goal = 0.0;
          final totals = snapshot.data![0];
          final targets = snapshot.data![1];

          switch (widget.macroType) {
            case MacroType.energy:
          current = totals['total_calories_consumed'];
          goal = targets['calorie_target'];
          break;
          case MacroType.carbs:
          current = totals['total_carbs_consumed'];
          goal = (targets['calorie_target'] * (targets['carb_percentage'] / 100) / 4);
          break;
          case MacroType.protein:
          current = totals['total_proteins_consumed'];
          goal = (targets['calorie_target'] * (targets['protein_percentage'] / 100) / 4);
          break;
          case MacroType.fat:
          current = totals['total_fats_consumed'];
          goal = (targets['calorie_target'] * (targets['fat_percentage'] / 100) / 9);
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
      } 
    );
}
}