import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/food_selection_pages/food_selection_all.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:provider/provider.dart';

class DiaryWidgetV2 extends StatefulWidget {
  const DiaryWidgetV2({
    super.key,
    required this.diaryName});

  final String diaryName;

  @override
  State<DiaryWidgetV2> createState() => _DiaryWidgetV2State();
}

class _DiaryWidgetV2State extends State<DiaryWidgetV2> {
  final ExpansibleController _controller = ExpansibleController();
  @override
  Widget build(BuildContext context) {
    return Consumer3<MacroGoal, TotalMacros, DiaryFoodList>(
      builder: (context, macroState, macroTotal, diaryFoodList, child) {
      return Expansible(
        headerBuilder: (context, isOpen) {
          return Column(
            children: [
              Container(
                  width: 365,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((20.0)),
                  color: Colors.white,
                  border: BoxBorder.all(
                    color: Colors.grey,
                  )
                ),
                child: ListTile(
                  title: Text(widget.diaryName),
                  subtitle: Text("${diaryFoodList.getCalorieAmount(widget.diaryName).toStringAsFixed(1)} Kcal"), // TODO: Implement switching between kcals and macros
                  leading:IconButton(
                  onPressed: () async {
                  final FoodItem? food = await Navigator.pushNamed<FoodItem>(
                    context,
                    foodSelectionRoute,
                    );
                  if (food != null) {
                   diaryFoodList.add(food, widget.diaryName);
                   macroTotal.addMacros(food);
                        }
                    },
                  icon: const Icon(Icons.add),                       
                  ),
                  trailing: Icon(_controller.isExpanded ? Icons.expand_less : Icons.expand_more),
                ),
              ),
            ],
          );
        },
        bodyBuilder: (context, isOpen) {
          return Container(
            margin: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 15.0),
            child: Column(
              children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                          children: diaryFoodList.getFoods(widget.diaryName.toLowerCase())
                              .map((food) => _buildFoodRow(food, context, diaryFoodList, macroTotal, widget.diaryName))
                              .toList(),
                        ),
              ],
            ),
          );
        },
        controller: _controller,
        expansibleBuilder: (context, header, body, animation) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (_controller.isExpanded) {
                  _controller.collapse();
                } else {
                  _controller.expand();
                }
              },
              child: header,
            ),
            SizeTransition(
              sizeFactor: animation,
              child: body,
            ),
            
          ],
        );
        }
      );
      }
    );
  }
}

Widget _buildFoodRow(FoodItem food, BuildContext context, DiaryFoodList foods, TotalMacros widgetInfo, String diaryName) {
    return Container(
        height: 50,
        width: 400,
        margin: EdgeInsets.fromLTRB(
          8.0,
          0.0,
          8.0,
          0.0
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            SizedBox(width: 15,),
            Text(food.productName.toString()),
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
                  foods.remove(food, diaryName);
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