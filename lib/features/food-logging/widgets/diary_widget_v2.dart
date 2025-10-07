import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/features/food-logging/arguments/diary_entry.dart';
import 'package:flutter_application_1/features/food-logging/classes/food_item.dart';
import 'package:flutter_application_1/features/food-logging/food_nutrition/food_nutrition_infopage.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:provider/provider.dart';

class DiaryWidgetV2 extends StatefulWidget {
  const DiaryWidgetV2({super.key, required this.diaryName});
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
        final bool isExpanded = _controller.isExpanded;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(isExpanded ? 0 : 20.0), // if expanded, bottom corners are not rounded
              bottomRight: Radius.circular(isExpanded ? 0 : 20.0),
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: ClipRRect( // clips its child with a round rectangle border of border radius 20
            borderRadius: BorderRadius.circular(20.0),
            child: Column(
              children: [
                _buildHeader(context, diaryFoodList, macroTotal),
                _buildBody(context, diaryFoodList, macroTotal),
              ],
            ),
          ),
        );
      },
    );
  }

Widget _buildBody(BuildContext context,DiaryFoodList diaryFoodList, TotalMacros macroTotal) {
  final isExpanded = _controller.isExpanded;
  final foods = diaryFoodList.getFoods(widget.diaryName.toLowerCase());

  return AnimatedSize(
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeInOut,
    child: isExpanded
        ? Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey),
              ),
            ),
            child: Column(
              children: [
                for (int i = 0; i < foods.length; i++) ... [ // triple dots is the spread operator, 
                //allows to insert a list of widgets into the children of the column
                  _buildFoodRow(
                    foods[i],
                    context,
                    diaryFoodList,
                    macroTotal,
                    widget.diaryName,
                  ),
                  if (i != foods.length - 1) // if the current iteration is not the last one
                    const Divider(height: 1, thickness: 1, color: Colors.grey),
                ],
              ],
            ),
          )
        : const SizedBox.shrink(),
  );
}

Widget _buildHeader(BuildContext context, DiaryFoodList diaryFoodList, TotalMacros macroTotal) {
  final isExpanded = _controller.isExpanded;

  return InkWell(
    onTap: () {
      setState(() {
        isExpanded ? _controller.collapse() : _controller.expand();
      });
    },
    child: ListTile(
      title: Text(widget.diaryName),
      leading: IconButton(
        onPressed: () async {
          final FoodItem? food = await Navigator.pushNamed<FoodItem>(
            context,
            foodSelectionRoute,
            arguments: DiaryEntryName(widget.diaryName),
          );
          if (food != null) {
            diaryFoodList.add(food, widget.diaryName);
            macroTotal.addMacros(food);
          }
        },
        icon: const Icon(Icons.add),
      ),
      trailing:
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${diaryFoodList.getCalorieAmount(widget.diaryName).toStringAsFixed(1)} Kcal",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )
      ),
      SizedBox(width: 20,),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
            ],
          ),
    ),
  );
}  

}


Widget _buildFoodRow(FoodItem food, BuildContext context, DiaryFoodList foods, TotalMacros widgetInfo, String diaryName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoodNutritionInfopage(food: food, diaryEntry: diaryName,)));
                },
                child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        SizedBox(width: 15,),
                        Text(food.productName.toString()),
                        SizedBox(width: 10),
                        Text(food.calories.toStringAsFixed(1)),
                        SizedBox(width: 10),              
                        Text('${food.carbs.toStringAsFixed(1)}C'),
                        SizedBox(width: 10),              
                        Text('${food.fats.toStringAsFixed(1)}F'),
                        SizedBox(width: 10),              
                        Text('${food.proteins.toStringAsFixed(1)}P'), 
                        SizedBox(width: 10,),
                        Flexible(
                          child: TextButton(
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
                        ),
                      ],
                
                
                    ),
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