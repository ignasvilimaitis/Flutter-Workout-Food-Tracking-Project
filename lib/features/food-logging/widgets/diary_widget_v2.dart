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
  const DiaryWidgetV2({super.key, required this.diaryName, required this.diaryDate, required this.diaryId});
  final String diaryName;
  final String diaryDate;
  final int diaryId;



  @override
  State<DiaryWidgetV2> createState() => _DiaryWidgetV2State();
}

class _DiaryWidgetV2State extends State<DiaryWidgetV2> {
  List<FoodItem> foodss = const [];
  final ExpansibleController _controller = ExpansibleController();
    FoodRepository repo = FoodRepository(FoodDataSource());

  @override
  void initState() {
    super.initState();
    _loadDiaryEntry();
  }

  Future<void> _loadDiaryEntry() async {

    await repo.getOrCreateDiaryEntryForSelectedDate(
      widget.diaryDate,
      widget.diaryId,
    );

    setState(() {}); 
  }

  @override
  void didUpdateWidget(covariant DiaryWidgetV2 oldWidget) {
    super.didUpdateWidget(oldWidget);

    // whenever user switches the date
    if (oldWidget.diaryDate != widget.diaryDate) {
      _loadDiaryEntry();
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Consumer4<MacroGoal, TotalMacros, DiaryFoodList, CurrentMacroDisplay>(
      builder: (context, macroState, macroTotal, diaryFoodList, currentMacroDisplay, child) {
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
                _buildHeader(context, macroTotal, currentMacroDisplay),
                _buildBody(context,macroTotal, currentMacroDisplay),
              ],
            ),
          ),
        );
      },
    );
  }

Widget _buildBody(
  BuildContext context,
  TotalMacros macroTotal,
  CurrentMacroDisplay currentMacroDisplay,
) {
  final isExpanded = _controller.isExpanded;
  if (!isExpanded) return const SizedBox.shrink();

  return FutureBuilder<List<Map<String, dynamic>>>(
    future: repo.getFoodsForDiaryEntry(widget.diaryDate, widget.diaryId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Error loading foods: ${snapshot.error}"),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox(height: 1,);
      } else {
        final foods = snapshot.data!;
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
                    _buildFoodRowFromMap(
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
    },
  );
}


Widget _buildHeader(BuildContext context, TotalMacros macroTotal,
 CurrentMacroDisplay currentDisplayedMacroType) {
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
            arguments: FoodSelectionArgs(
              widget.diaryName,
              widget.diaryDate,
              widget.diaryId,));

          if (food != null) {
            final diaryEntry = await repo.getOrCreateDiaryEntryForSelectedDate(
              widget.diaryDate,
              widget.diaryId,
            );

            await repo.addFoodToDiaryEntry(
              diaryEntry['pk_diaryentry_id'],
              food.id,
              quantity: 1,
            );

            macroTotal.addMacros(food);

            final newFoods = await repo.getFoodsForDiaryEntry(
              widget.diaryDate,
              widget.diaryId,
            );

            setState(() {
              foodss = newFoods.map((f) => FoodItem.fromMap(f)).toList();
            });
          }
        },
                icon: const Icon(Icons.add),
      ),
      trailing:
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                              color: currentDisplayedMacroType.getCurrentDisplay() == MacroType.protein ?
                            Color.fromARGB(255, 106, 206, 110) : currentDisplayedMacroType.getCurrentDisplay() == MacroType.fat ? Colors.orange
                                   : currentDisplayedMacroType.getCurrentDisplay() == MacroType.carbs ? Colors.blue : getThemeData().primaryColor,
                              borderRadius: BorderRadius.circular(7),
                            ),
                child: getCurrentDisplayedMacroHeader(foodss, macroTotal,
                widget.diaryName, currentDisplayedMacroType.getCurrentDisplay())
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

Widget getCurrentDisplayedMacroHeader(List<FoodItem> foods,
 TotalMacros widgetInfo, String diaryName, MacroType currentDisplayedMacroType) {
  switch (currentDisplayedMacroType) {
    case MacroType.energy:
      return Text(
        "${getMacroTotal(foods, MacroType.energy).toStringAsFixed(1)} Kcal",
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      );
    case MacroType.carbs:
      return Text(
        "${getMacroTotal(foods, MacroType.carbs).toStringAsFixed(1)} g",
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      );
    case MacroType.protein:
      return Text(
        "${getMacroTotal(foods, MacroType.protein).toStringAsFixed(1)} g",
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      );
    case MacroType.fat:
      return Text(
        "${getMacroTotal(foods, MacroType.fat).toStringAsFixed(1)} g",
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      );
  }
}

double getMacroTotal(List<FoodItem> foods, MacroType currentDisplayedMacroType) {
  double macroTotal = 0;
  for (FoodItem food in foods) {
    switch (currentDisplayedMacroType) {
      case MacroType.energy:
        macroTotal += food.calories;
      case MacroType.carbs:
        macroTotal += food.carbs;
      case MacroType.fat:
        macroTotal += food.fats;
      case MacroType.protein:
        macroTotal += food.proteins;
      }
    }
  return macroTotal;
  }

Widget _buildFoodRowFromMap(
  Map<String, dynamic> foodMap,
  BuildContext context,
  String diaryName,
  MacroType currentDisplayedMacroType,
) {
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
                    food: FoodItem.fromMap(foodMap),
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
                    Text(
                      foodMap['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    if (foodMap['brand'] != null)
                      Text(
                        foodMap['brand'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 12.0,
                        ),
                      ),
                    if (foodMap['servingSize'] != null)
                      Text(
                        foodMap['servingSize'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[900]),
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
                  child: getCurrentDisplayedMacroBodyFromMap(foodMap, currentDisplayedMacroType),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


Widget getCurrentDisplayedMacroBodyFromMap(
  Map<String, dynamic> foodMap,
  MacroType currentDisplayedMacroType,
) {
  switch (currentDisplayedMacroType) {
    case MacroType.energy:
      return Text("${foodMap['calories']?.toStringAsFixed(1) ?? '0'} kcal", style: const TextStyle(fontSize: 12));
    case MacroType.carbs:
      return Text("${foodMap['carbs']?.toStringAsFixed(1) ?? '0'} g", style: const TextStyle(fontSize: 12));
    case MacroType.protein:
      return Text("${foodMap['proteins']?.toStringAsFixed(1) ?? '0'} g", style: const TextStyle(fontSize: 12));
    case MacroType.fat:
      return Text("${foodMap['fats']?.toStringAsFixed(1) ?? '0'} g", style: const TextStyle(fontSize: 12));
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