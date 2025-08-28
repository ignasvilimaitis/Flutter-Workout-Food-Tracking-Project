import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/food_selection.dart';
import 'package:flutter_application_1/features/food-logging/widgets/diary_widget.dart';
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
  Widget breakfastWidget = DiaryWidget(diaryName: 'Breakfast');
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
      body: Consumer2<WidgetCalorieState, FoodModel>(
          builder: (context, widgetState, foodState, child  ) {
          return ListView(
            children: <Widget> [
             Column(
              children: [
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
                          children: foodState._foods.map((food) => _buildFoodRow(food)).toList(),
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
  
  //void remove TODO: Removal of foods
  }
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
  
  //void remove TODO: Removal of macros
  }
}

Widget _buildFoodRow(FoodItem food) {
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
            Text(food.name.toString()),
            SizedBox(width: 10),
            Text(food.calories.toString()),
            SizedBox(width: 10),              
            Text('${food.carbs.toString()}C'),
            SizedBox(width: 10),              
            Text('${food.fats.toString()}F'),
            SizedBox(width: 10),              
            Text('${food.proteins.toString()}P'),          
          ],


        ),
      );
}