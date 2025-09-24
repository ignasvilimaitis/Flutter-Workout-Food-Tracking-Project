import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:flutter_application_1/features/food-logging/widgets/ui_button.dart';
import 'package:provider/provider.dart';

class FoodNutritionInfopage extends StatefulWidget {
  final FoodItem food;
  const FoodNutritionInfopage({super.key, required this.food});

  @override
  State<FoodNutritionInfopage> createState() => _FoodNutritionInfopageState();
}

class _FoodNutritionInfopageState extends State<FoodNutritionInfopage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<TotalMacros, MacroGoal>(
        builder: (context, totalMacros, macroGoals, child) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: [
                  // Header
                  Padding(padding: EdgeInsetsGeometry.only(top: 15)),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      UIButton(
                        iconData: Icons.keyboard_return,
                        function: 'Return',
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 225,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((16.0)),
                          color: Colors.white,
                        ),
                        child: Row(children: [Text(widget.food.productName)]),
                      ),
                      SizedBox(width: 10),
                      UIButton(
                        iconData: Icons.favorite_outline_outlined,
                        function: 'Return',
                      ),
                      SizedBox(width: 10),
                      UIButton(iconData: Icons.more_horiz, function: 'Return'),
                    ],
                  ),
                  SizedBox(height: 25),
                  // Top container
                  Container(
                    width: 390,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        // Pie Chart
                        SizedBox(
                          height: 175,
                          width: 175,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PieChart(
                                PieChartData(
                                  sectionsSpace: 5.0,
                                  sections: [
                                    PieChartSectionData(
                                      color: const Color.fromARGB(
                                        255,
                                        99,
                                        199,
                                        102,
                                      ),
                                      radius: 12.0,
                                      value: widget.food.carbs,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.blue,
                                      radius: 12.0,
                                      value: widget.food.proteins,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      color: Colors.orange,
                                      radius: 12.0,
                                      value: widget.food.fats,
                                      showTitle: false,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.food.calories.toStringAsFixed(1)} Kcal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "P - ${widget.food.proteins.toStringAsFixed(1)}g",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    "C - ${widget.food.carbs.toStringAsFixed(1)}g",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        99,
                                        199,
                                        102,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "F - ${widget.food.fats.toStringAsFixed(1)}g",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 14),
                        Column(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Amount :"),
                                SizedBox(width: 7),
                                Container(
                                  width: 100,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Serving :"),
                                SizedBox(width: 7),
                                Container(
                                  width: 100,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Entry :"),
                                SizedBox(width: 22),
                                Container(
                                  width: 100,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Time :"),
                                SizedBox(width: 22),
                                // 24H time format (this block is the hour)
                                Container(
                                  width: 50,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                SizedBox(width: 5),
                                // This block are the minutes
                                Container(
                                  width: 50,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 390,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              const Text(
                                "Calories",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),

                              SizedBox(width: 180),
                              Text(
                                "${(totalMacros.calorieAmount + widget.food.calories).toStringAsFixed(1)}/${macroGoals.calorieGoal}",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 360,
                          child: Stack(
                            children: [
                              LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(16.0),
                                minHeight: 10,
                                value:0
                              ),
                              LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(16.0),
                              value: (totalMacros.calorieAmount + widget.food.calories) / macroGoals.calorieGoal,
                              minHeight: 10,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color.fromARGB(255, 158, 109, 109),
                              ),
                            ),
                            LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(16.0),
                              value:
                                  totalMacros.calorieAmount /
                                  macroGoals.calorieGoal,
                              minHeight: 10,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color.fromARGB(255, 116, 11, 11),
                              ),
                            ),
                            ]
                          ),
                        ),
                        SizedBox(width: 20,),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      backgroundColor: getThemeData().primaryColor,
    );
  }
}
