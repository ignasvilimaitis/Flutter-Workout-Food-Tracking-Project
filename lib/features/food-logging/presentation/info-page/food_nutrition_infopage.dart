import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums.dart';
import 'package:flutter_application_1/core/local_time.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/features/food-logging/data/food_view_model.dart';
import 'package:flutter_application_1/features/food-logging/presentation/widgets/nutrition_progress_bar.dart';
import 'package:flutter_application_1/features/food-logging/presentation/widgets/ui_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';


class FoodNutritionInfopage extends StatefulWidget {
  final FoodItem food;
  final String diaryEntry;
  const FoodNutritionInfopage({
    super.key,
    required this.food,
    required this.diaryEntry,
    });

  @override
  State<FoodNutritionInfopage> createState() => _FoodNutritionInfopageState();
}

class _FoodNutritionInfopageState extends State<FoodNutritionInfopage> {
  late int foodAmount = 1; //Food amount is 1 by default

  

  @override
  Widget build(BuildContext context) {
    const int maxNameLength = 25;

String truncatedName =
    widget.food.name.length > maxNameLength
        ? '${widget.food.name.substring(0, maxNameLength)}…'
        : widget.food.name;
    return Scaffold(
      body: Consumer<FoodViewModel>(
        builder: (context, foodViewModel, child) {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(truncatedName, overflow: TextOverflow.ellipsis,)]),
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
                                    '${(widget.food.calories * foodAmount).toStringAsFixed(1)} Kcal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "P - ${(widget.food.proteins * foodAmount).toStringAsFixed(1)}g",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    "C - ${(widget.food.carbs * foodAmount).toStringAsFixed(1)}g",
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
                                    "F - ${(widget.food.fats * foodAmount).toStringAsFixed(1)}g",
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
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      borderRadius: BorderRadius.circular(12.0),
                                      value: foodAmount,
                                      isExpanded: true,
                                      isDense: true,
                                      onChanged: (value) => {
                                        print('Selected amount: $value'),
                                        setState(() {
                                          foodAmount = value!;
                                        })
                                      },
                                      items: List.generate(
        5,
        (i) => DropdownMenuItem(
          value: i + 1,
          child: Align(
            alignment: Alignment.center, // centers text inside menu
            child: Text('${i + 1}'),
          ),
        ),
      ),
                                  ),
                              
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
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    
                                  ),
                                  child: Text(widget.food.servingSize, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text("Entry :"),
                                SizedBox(width: 22),
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(widget.diaryEntry),
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
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    LocalTime().militaryTimeH),
                                ),
                                SizedBox(width: 5),
                                // This block is the minutes
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(
                                      width: 2,
                                      color: getThemeData().primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(LocalTime().militaryTimeM),
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

                              Spacer(),
                              Text(
                                "${(foodViewModel.macroTotals['calories'] !+ (widget.food.calories * foodAmount)).toStringAsFixed(1)}/${foodViewModel.macroTargets['calories']}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                              value: (foodViewModel.macroTotals['calories'] !+ widget.food.calories) / foodViewModel.macroTargets['calories']!,
                              minHeight: 10,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color.fromARGB(255, 158, 109, 109),
                              ),
                            ),
                            LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(16.0),
                              value:
                                  foodViewModel.macroTotals['calories']! /
                                  foodViewModel.macroTargets['calories']!,
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
                  SizedBox(height: 20,),
                  Container(
                    width: 390,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                    ),
                    child:  Column(
                      children: [
                        SizedBox(height: 5,),
                        const Text("OpenFoodFacts",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        ),
                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text("Nutrient Breakdown",
                              style: TextStyle(
                                fontSize: 16
                              ),
                              ),
                              SizedBox(width: 15,),
                              Text(widget.food.servingSize.toString()),
                            
                            ],
                          ),
                        ),
                            Column(
                                children: [
                                  NutritionProgressBar(
                                    widgetColor: const Color.fromARGB(223, 146, 30, 30),
                                    nutrientType: NutrientType.energy,
                                    food: widget.food,
                                    nutrientName: 'Energy'),
                                    SizedBox(height: 10,),
                                  NutritionProgressBar(
                                    widgetColor: Colors.blueAccent,
                                    nutrientType: NutrientType.protein,
                                    food: widget.food,
                                    nutrientName: 'Protein'),
                                  SizedBox(height: 10,),  
                                  NutritionProgressBar(
                                    widgetColor: Colors.orange,
                                    nutrientType: NutrientType.fat,
                                    food: widget.food,
                                    nutrientName: 'Fat'), 
                                   SizedBox(height: 10,),
                                  NutritionProgressBar(
                                    widgetColor: const Color.fromARGB(255, 99,199, 102,),
                                    nutrientType: NutrientType.carbs,
                                    food: widget.food,
                                    nutrientName: 'Carbs'),                                                                   
                                ],
                              )
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
