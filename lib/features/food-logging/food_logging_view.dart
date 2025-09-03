import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/food_selection.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
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
      body: Consumer3<WidgetCalorieState, FoodModel, MacroModel>(
          builder: (context, widgetState, foodState, macroState, child) {
          return ListView(
            shrinkWrap: true,
            children: <Widget> [
              Column(
                children: [
                  // Header
                  Padding(padding: EdgeInsetsGeometry.only(top: 15)
                  ),
                  Row(children: [
                    SizedBox(width: 10),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((16.0)),
                      color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.keyboard_return)),
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 45,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((16.0)),
                      color: Colors.white,
              ),
                      child: Row(
                      children: [
                        Icon(
                          Icons.arrow_left,
                          size: 50,),
                        SizedBox(width: 29),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text(
                            today,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                        ),
                        SizedBox(width: 29),
                        Icon(
                          Icons.arrow_right,
                          size: 50,),
                      ],
                    )),

                  ],
                  ),
                   // Scrollable Widget Row
                  Container(
                    margin: EdgeInsets.fromLTRB(
                    8.0,
                    24.0,
                    8.0,
                    0.0
                    ),
                    width: 400,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular((20.0)),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Targets',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),),
                              ),
                              // Carbs Progress Bar
                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height: 30,
                                alignment: Alignment.center,
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Carbs: ',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(255, 82, 82, 82),
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 12.0,
                                                  ),
                                              ),
                                              TextSpan(
                                                text: '${widgetState.carbAmount.toStringAsFixed(1)}g',
                                                style: TextStyle(
                                                color: const Color.fromARGB(255, 82, 82, 82),
                                                fontWeight: FontWeight.w100,
                                                fontSize: 12.0),
                                              ),
              
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          "${macroState.carbGoal}g",
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 82, 82, 82),
                                            fontWeight: FontWeight.w100,
                                            fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                    value: widgetState.carbAmount / macroState.carbGoal,
                                    minHeight: 10,
                                    color: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),               
                                                                  ),
                                  ],
                                )
                              
                              ),
                              SizedBox(height: 25),
                              // Fats Progress Bar
                        Container(
                         width: MediaQuery.of(context).size.width * 0.85,
                         height: 30,
                         alignment: Alignment.center,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                                text: 'Fats: ',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(255, 82, 82, 82),
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 12.0,
                                                  ),
                                              ),
                                              TextSpan(
                                                text: '${widgetState.fatAmount.toStringAsFixed(1)}g',
                                                style: TextStyle(
                                                color: const Color.fromARGB(255, 82, 82, 82),
                                                fontWeight: FontWeight.w100,
                                                fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                       Spacer(),
                                        Text(
                                          "${macroState.fatGoal}g",
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 82, 82, 82),
                                            fontWeight: FontWeight.w100,
                                            fontSize: 12.0),
                                        ),
                                ],
                              ),
                                    LinearProgressIndicator(
                                    value: widgetState.fatAmount / macroState.fatGoal,
                                    minHeight: 10,
                                    color: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 250, 113, 71)),
                                                        
                                    ),
                                  ],
                                )
                              ),
                              SizedBox(height: 25),
                              // Protein Progress Bar
                        Container(
                         width: MediaQuery.of(context).size.width * 0.85,
                         height: 30,
                         alignment: Alignment.center,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                                text: 'Proteins: ',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(255, 82, 82, 82),
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 12.0,
                                                  ),
                                              ),
                                              TextSpan(
                                                text: '${widgetState.proteinAmount.toStringAsFixed(1)}g',
                                                style: TextStyle(
                                                color: const Color.fromARGB(255, 82, 82, 82),
                                                fontWeight: FontWeight.w100,
                                                fontSize: 12.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      Spacer(),
                                      Text(
                                          "${macroState.proteinGoal}g",
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 82, 82, 82),
                                            fontWeight: FontWeight.w100,
                                            fontSize: 12.0),
                                        ),
                                ],
                              ),
                                    LinearProgressIndicator(
                                    value: widgetState.fatAmount / macroState.fatGoal,
                                    minHeight: 10,
                                    color: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 67, 204, 67),),
                                                        
                                    ),
                                  ],
                                )
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),    
            // First diary widget block (Breakfast)      
            IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.fromLTRB(
                8.0,
                24.0,
                8.0,
                15.0
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((20.0)),
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
                      children: foodState.foods.map((food) => _buildFoodRow(food, context, foodState, widgetState)).toList(),
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
              ],
            );
          }
          ),
         backgroundColor: Theme.of(context).colorScheme.primary,
      );
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
                final toRemove = await showConfirmDialog(context) ?? false;
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

Future<bool?> showConfirmDialog(BuildContext context) {
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