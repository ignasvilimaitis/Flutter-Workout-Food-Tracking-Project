import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/food_selection.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

DateTime date = DateTime.now();
String today = '${date.day}th ${DateFormat('MMMM').format(date)} ${date.year}';

class FoodLoggingView extends StatefulWidget {

  const FoodLoggingView({super.key});
  

  @override
  State<FoodLoggingView> createState() => _FoodLoggingViewState();
}

class _FoodLoggingViewState extends State<FoodLoggingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(today),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_left,
            size: 40.0,
            ),
          ),
          actions: [
            Icon(
              Icons.arrow_right,
              size: 40.0,
              ),
          ],
      centerTitle: true,
      ),
      body: Consumer3<WidgetCalorieState, FoodModel, MacroModel>(
          builder: (context, widgetState, foodState, macroState, child  ) {
          return ListView(
            shrinkWrap: true,
            children: <Widget> [
             Column(
              children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.fromLTRB(
                    8.0,
                    24.0,
                    8.0,
                    15.0
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((3.0)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 200,
                          width: 150,
                          child: PieChart(
                              PieChartData(     
                                startDegreeOffset: 360,                                                        
                                centerSpaceRadius: 25,
                                sections: [
                                  PieChartSectionData(
                                    value: macroState.carbGoal - widgetState.carbAmount,
                                    showTitle: false,
                                    color: const Color.fromARGB(0, 68, 64, 64),
                                    radius: 15,
                                  ),
                                  PieChartSectionData(
                                    titlePositionPercentageOffset: -1.7,
                                    value: (widgetState.carbAmount),
                                    color: Colors.blue,
                                    title: 'Carbs',
                                    radius: 15,                                
                                  ),
                                ]
                              )
                            
                            ),
                        ),
                        SizedBox(
                          height: 200,
                          width: 50,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 25,
                              sections: [
                                    PieChartSectionData(
                                      titlePositionPercentageOffset: -1.7,
                                      value: (widgetState.fatAmount),
                                      color: Colors.red,
                                      title: 'Fat',
                                      radius: 15,
                                    ),
                                  ]
                          ),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          width: 150,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 25,
                              sections: [
                            PieChartSectionData(
                                      titlePositionPercentageOffset: -1.7,
                                      value: (widgetState.fatAmount),
                                      color: Colors.green,
                                      title: 'Protein',
                                      radius: 15,
                                    ),
                            
                                                ]
                            ),
                                        
                          ),
                        )
                      ],
                    ),
                  )
              ),                  
                IntrinsicHeight(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                    8.0,
                    24.0,
                    8.0,
                    15.0
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular((3.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                            height: 50,
                          ),
                          Text("Breakfast"),
                          SizedBox(width: 15),
                          Text("Cals ${widgetState.calorieAmount.toStringAsFixed(1)}"),
                          SizedBox(width: 5,),
                          Text("Carbs ${widgetState.carbAmount.toStringAsFixed(1)} "),
                          SizedBox(width: 5),                        
                          Text("Fat ${widgetState.fatAmount.toStringAsFixed(1)}"),
                          SizedBox(width: 5),                        
                          Text("Protein ${widgetState.proteinAmount.toStringAsFixed(1)}"),                        
                          
                        ],
                      ),
                    
                      Column(
                        mainAxisSize: MainAxisSize.min,
                          children: foodState._foods.map((food) => _buildFoodRow(food, context, foodState, widgetState)).toList(),
                        ),
                        FilledButton.icon(
                            onPressed: () async {
                              final food = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FoodSelector()));
                              if ((food != null)) {
                                setState(() {
                                  foodState.add(food);
                                  widgetState.addMacros(food);
                              });
                              }
                            },
                            label: Text('Add Food'),
                            icon: const Icon(Icons.add),                       
                          ),            
                    ],
                  )
                ),
              ),
                ElevatedButton(
                  onPressed: () {
                    
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Return",
                    style: TextStyle(
                      color: Colors.blue 
                    ),),)
              ],
            ),
            ]
          );
          }
          ),
         backgroundColor: Colors.grey,
      );
  }
}

class FoodModel extends ChangeNotifier {
  final List<FoodItem> _foods = [];

  List<FoodItem> get foods => _foods;

  void add(FoodItem food) {
    _foods.add(food);
    notifyListeners();
  

  }
  void remove(FoodItem food) {
    _foods.remove(food);
    notifyListeners();
  }
}

class MacroModel extends ChangeNotifier {
   double carbGoal = 100;
   double fatGoal = 80;
   double proteinGoal = 100;
   double get calorieGoal => (carbGoal * 4) + (fatGoal * 8) + (proteinGoal * 4);



  
}

class WidgetCalorieState extends ChangeNotifier {
  double calorieAmount = 0;
  double carbAmount = 0;
  double fatAmount = 0;
  double proteinAmount = 0;

  void addMacros(FoodItem food) {
    calorieAmount += food.calories;
    carbAmount += food.carbs;
    fatAmount += food.fats;
    proteinAmount += food.proteins;
    notifyListeners();

  }

  void removeMacros(FoodItem food) {
    calorieAmount -= food.calories;
    carbAmount -= food.carbs;
    fatAmount -= food.fats;
    proteinAmount -= food.proteins;
    notifyListeners();
  }
}

Widget _buildFoodRow(FoodItem food, BuildContext context, FoodModel foods, WidgetCalorieState widgetInfo) {
    return Container(
        height: 50,
        width: 400,
        margin: EdgeInsets.fromLTRB(
          8.0,
          0.0,
          8.0,
          15.0
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((3.0)),
          border: BoxBorder.all(),        
        ),
        child: Row(
          children: [
            SizedBox(width: 15,),
            Text(food.name.toString()),
            SizedBox(width: 10),
            Text(food.calories.toString()),
            SizedBox(width: 10),              
            Text('${food.carbs.toString()}C'),
            SizedBox(width: 10),              
            Text('${food.fats.toString()}F'),
            SizedBox(width: 10),              
            Text('${food.proteins.toString()}P'), 
            SizedBox(width: 50,),
            TextButton(
              onPressed: () async {
                final toRemove = await ShowConfirmDialog(context) ?? false;
                if (toRemove) {
                  foods.remove(food);
                  widgetInfo.removeMacros(food);

                } else {
                  return;
                }
              },
             child: const Text(
              'Remove',
              style: TextStyle(
                color: Colors.red,
              ),
             ),
             ),
          ],


        ),
      );
}

Future<bool?> ShowConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Are you sure you want to remove this item?"),
        actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
      );
    }
  );
}