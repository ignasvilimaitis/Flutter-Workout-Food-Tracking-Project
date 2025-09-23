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
                    width: 380,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15),
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
                                      color: Colors.green,
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
                                  Text('${widget.food.calories} Kcal'),
                                  Text(
                                    "P - ${widget.food.proteins.toStringAsFixed(1)}g",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    "C - ${widget.food.carbs.toStringAsFixed(1)}g",
                                    style: TextStyle(color: Colors.green),
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
