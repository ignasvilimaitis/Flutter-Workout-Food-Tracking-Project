import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/food_selection.dart';

class DiaryWidget extends StatefulWidget {
  const DiaryWidget({
    super.key,
    required this.diaryName,
    });

  final String diaryName;

  @override
  State<DiaryWidget> createState() => _DiaryWidgetState();
}

class _DiaryWidgetState extends State<DiaryWidget> {
  List<FoodItem> foodItems = [];

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
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
                        Text(widget.diaryName),
                        SizedBox(width: 15),
                        //Text("Cals ${calorieAmount.toStringAsFixed(1)}"),
                        SizedBox(width: 5,),
                        //Text("Carbs ${carbAmount.toStringAsFixed(1)} "),
                        SizedBox(width: 5),                        
                        //Text("Fat ${fatAmount.toStringAsFixed(1)}"),
                        SizedBox(width: 5),                        
                        //Text("Protein ${proteinAmount.toStringAsFixed(1)}"),                        
                        
                      ],
                    ),
                  
                    Column(
                      mainAxisSize: MainAxisSize.min,
                        children: foodItems.map((food) => _buildFoodRow(food)).toList(),
                      ),
                      FilledButton.icon(
                          onPressed: () async {
                            final food = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FoodSelector()));
                            if ((food != null)) {
                              setState(() {
                                foodItems.add(food);
                                //FoodModel().add(food);
                            });
                            }
                          },
                          label: Text('Add Food'),
                          icon: const Icon(Icons.add),                       
                        ),            
                  ],
                )
              ),
            );
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
    