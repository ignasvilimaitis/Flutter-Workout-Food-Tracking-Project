import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/core/theme.dart';
import 'package:flutter_application_1/core/utils/helpers.dart';
import 'package:flutter_application_1/features/food-logging/arguments/food_selection_args.dart';
import 'package:flutter_application_1/features/food-logging/data/food_data_source.dart';
import 'package:flutter_application_1/features/food-logging/data/food_model.dart';
import 'package:flutter_application_1/features/food-logging/data/food_repository.dart';
import 'package:flutter_application_1/features/food-logging/food_nutrition/food_nutrition_infopage.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class DiaryWidgetV2 extends StatefulWidget {
  const DiaryWidgetV2({super.key, required this.diaryName, required this.diaryId});
  final String diaryName;
  final int diaryId;



  @override
  State<DiaryWidgetV2> createState() => _DiaryWidgetV2State();
}

class _DiaryWidgetV2State extends State<DiaryWidgetV2> {
  final ExpansibleController _controller = ExpansibleController();
    FoodRepository repo = FoodRepository(FoodDataSource());

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DiaryWidgetV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
  

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentMacroDisplay>(
      builder: (context, currentMacroDisplay, child) {
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
                _buildHeader(context, currentMacroDisplay),
                _buildBody(context, currentMacroDisplay),
              ],
            ),
          ),
        );
      },
    );
  }

Widget getCurrentDisplayedMacroNumber(
  List<FoodItem> foods,
  MacroType type,
) {
  final value = getMacroTotal(foods, type);

  return Text(
    type == MacroType.energy
        ? '${value.toStringAsFixed(1)} kcal'
        : '${value.toStringAsFixed(1)} g',
    style: const TextStyle(fontSize: 14),
  );
}



Widget _buildBody(
  BuildContext context,
  CurrentMacroDisplay currentMacroDisplay,
) {
  final isExpanded = _controller.isExpanded;
  if (!isExpanded) return const SizedBox.shrink();

  return Consumer<FoodViewModel> 
  (builder: (context, foodViewModel, child) {
    final foods = foodViewModel.foodsForDiary(widget.diaryId);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(height: 1, thickness: 1, color: Colors.grey),
            ...List.generate(
              foods.length,
              (i) {
                final foodMap = foods[i];
                return Column(
                  children: [
                    _buildFoodRow(
                      foodMap,
                      context,
                      widget.diaryName,
                      currentMacroDisplay.getCurrentDisplay(),
                    ),
                    if (i != foods.length - 1)
                      const Divider(height: 1, thickness: 1, color: Colors.grey),
                  ],
                );
              },
            ),
          ],
        );

      }
  );
    }


Color _macroColor(MacroType type) {
  switch (type) {
    case MacroType.protein:
      return const Color.fromARGB(255, 106, 206, 110);
    case MacroType.carbs:
      return Colors.blue;
    case MacroType.fat:
      return Colors.orange;
    case MacroType.energy:
      return getThemeData().primaryColor;
  }
}

Widget _buildHeader(
  BuildContext context,
  CurrentMacroDisplay currentDisplayedMacroType,
) {
  final isExpanded = _controller.isExpanded;

  return Consumer<FoodViewModel>(
    builder: (context, foodViewModel, _) {
      final foods = foodViewModel.foodsForDiary(widget.diaryId);

      return InkWell(
        onTap: () {
          setState(() {
            isExpanded ? _controller.collapse() : _controller.expand();
          });
        },
        child: ListTile(
          title: Text(widget.diaryName),
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final FoodItem? food =
                  await Navigator.pushNamed<FoodItem>(
                context,
                foodSelectionRoute,
                arguments: FoodSelectionArgs(
                  widget.diaryName,
                  foodViewModel.selectedDate,
                  widget.diaryId,
                ),
              );

              if (food != null) {
                await foodViewModel.addFood(
                  widget.diaryId,
                  food,
                );
              }
            },
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _macroColor(
                    currentDisplayedMacroType.getCurrentDisplay(),
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: getCurrentDisplayedMacroNumber(
                  foods,
                  currentDisplayedMacroType.getCurrentDisplay(),
                ),
              ),
              const SizedBox(width: 20),
              Icon(isExpanded
                  ? Icons.expand_less
                  : Icons.expand_more),
            ],
          ),
        ),
      );
    },
  );
}

}

double getMacroTotal(List<FoodItem> foods, MacroType currentDisplayedMacroType) {
  double macroTotal = 0;

  for (FoodItem food in foods) {
    switch (currentDisplayedMacroType) {
      case MacroType.energy:
        macroTotal += food.calories;
        break;
      case MacroType.carbs:
        macroTotal += food.carbs;
        break;
      case MacroType.fat:
        macroTotal += food.fats;
        break;
      case MacroType.protein:
        macroTotal += food.proteins;
        
    }
  }

  return macroTotal;
}


// Widget for each food within a diary
Widget _buildFoodRow(
  FoodItem food,
  BuildContext context,
  String diaryName,
  MacroType currentDisplayedMacroType,
) {

  String name = food.name;

const int maxNameLength = 20;

String truncatedName =
    name.length > maxNameLength
        ? '${name.substring(0, maxNameLength)}…'
        : name;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
    child: Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              // Open nutrition info page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FoodNutritionInfopage(
                    food: food,
                    diaryEntry: diaryName,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Icon(Icons.fastfood, size: 24.0, color: Colors.grey[700]),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich( 
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: truncatedName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: bullet + (food.brand ?? 'Generic'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 66, 66, 66),
                              fontWeight: FontWeight.bold,
                            ),
                          
                          ),
                        ]

                            ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(3),
                  width: 59,
                  height: 30,
                  decoration: BoxDecoration(
                    color: currentDisplayedMacroType == MacroType.protein
                        ? const Color.fromARGB(255, 106, 206, 110)
                        : currentDisplayedMacroType == MacroType.fat
                            ? Colors.orange
                            : currentDisplayedMacroType == MacroType.carbs
                                ? Colors.blue
                                : getThemeData().primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: getCurrentDisplayedMacroBody(food, currentDisplayedMacroType),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


Widget getCurrentDisplayedMacroBody(
  FoodItem food,
  MacroType currentDisplayedMacroType,
) {
  switch (currentDisplayedMacroType) {
    case MacroType.energy:
      return Text("${food.calories.toStringAsFixed(1)} kcal", style: const TextStyle(fontSize: 12));
    case MacroType.carbs:
      return Text("${food.carbs.toStringAsFixed(1)} g", style: const TextStyle(fontSize: 12));
    case MacroType.protein:
      return Text("${food.proteins.toStringAsFixed(1)} g", style: const TextStyle(fontSize: 12));
    case MacroType.fat:
      return Text("${food.fats.toStringAsFixed(1)} g", style: const TextStyle(fontSize: 12));
  }
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

// Flexible(
//                           child: TextButton(
//                             onPressed: () async {
//                               final toRemove = await showConfirmDialog(context) ?? false;
//                               if (toRemove) {
//                                 foods.remove(food, diaryName);
//                                 widgetInfo.removeMacros(food);
//                               } else {
//                                 return;
//                               }
//                             },
//                            child: const Text(
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             'Remove',
//                             style: TextStyle(
//                               color: Colors.red,
//                             ),
//                            ),
//                            ),
//                         ),