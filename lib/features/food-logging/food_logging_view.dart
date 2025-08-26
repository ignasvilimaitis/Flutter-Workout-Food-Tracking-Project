import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/features/food-logging/food_selection.dart';
import 'package:intl/intl.dart';

List<Widget> breakfastList = [];
List<Widget> lunchList = [];
DateTime date = DateTime.now();
String today = '${date.day}th ${DateFormat('MMMM').format(date)} ${date.year}';

class FoodLoggingView extends StatefulWidget {

  const FoodLoggingView({super.key});
  

  @override
  State<FoodLoggingView> createState() => _FoodLoggingViewState();
}

class _FoodLoggingViewState extends State<FoodLoggingView> {
  late FoodItem food;
  late double carbAmount = 0;
  late double fatAmount = 0;
  late double proteinAmount = 0;
  late double calorieAmount = 0;

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
      body: ListView(
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
                  borderRadius: BorderRadius.circular((16.0)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.all(15)),
                        const Text("Breakfast"),
                        //SizedBox(width: 20),
                        Text("Calories $calorieAmount"),
                        //SizedBox(width: 20),
                        Text("Carbs $carbAmount"),
                        //SizedBox(width: 10),                        
                        Text("Fat $fatAmount"),
                        //SizedBox(width: 10),                        
                        Text("Protein $proteinAmount"),                        
                        
                      ],
                    ),
                    
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: breakfastList,),
                      FilledButton.icon(
                          onPressed: () async {
                            final food = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FoodSelector()));
                            if ((food) == null) {
                              // Return Call?
                            }
                            
                            setState(() {
                              buildRow(food.name,food.calories, food.carbs, food.fats,food.proteins, breakfastList);
                              calorieAmount += food.calories;
                              carbAmount += food.carbs;
                              fatAmount += food.fats;
                              proteinAmount += food.proteins;
                            });
                              
                          },
                          label: Text('Add Food'),
                          icon: const Icon(Icons.add),
                          
                        ),

                  ],
                )
              ),
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
                  borderRadius: BorderRadius.circular((16.0)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.all(20)),
                        const Text("Lunch"),
                        SizedBox(width: 20),
                        Text("Carbs ${carbAmount.toStringAsFixed(1)} "),
                        SizedBox(width: 10),                        
                        Text("Fat ${fatAmount.toStringAsFixed(1)}"),
                        SizedBox(width: 10),                        
                        Text("Protein ${proteinAmount.toStringAsFixed(1)}"),                        
                        
                      ],
                    ),
                    
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: lunchList,),
                      FilledButton.icon(
                          onPressed: () {
                          setState(() {
                          });
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
      ),
      backgroundColor: Colors.grey,

  );
  }
}

buildRow(name, calories, carbs, fats, proteins,list) {
  list.add(
    Container(
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
            Text(name.toString()),
            SizedBox(width: 10),
            Text(calories.toString()),
            SizedBox(width: 10),              
            Text('${carbs.toString()}C'),
            SizedBox(width: 10),              
            Text('${fats.toString()}F'),
            SizedBox(width: 10),              
            Text('${proteins.toString()}P'),          
          ],


        ),
      )
  );
}