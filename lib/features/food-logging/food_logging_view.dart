import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/classes/Food_Item.dart';
import 'package:flutter_application_1/features/food-logging/food_selection.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<TotalMacros, MacroGoal>(
          builder: (context, totalMacros, macroGoals, child) {
          return ListView(
            //shrinkWrap: true,
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
                                                text: '${totalMacros.carbAmount.toStringAsFixed(1)}g',
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
                                          "${macroGoals.carbGoal - totalMacros.carbAmount}g",
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 82, 82, 82),
                                            fontWeight: FontWeight.w100,
                                            fontSize: 12.0),
                                        ),
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                    value: totalMacros.carbAmount / macroGoals.carbGoal,
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
                                                text: '${totalMacros.fatAmount.toStringAsFixed(1)}g',
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
                                          "${macroGoals.fatGoal - totalMacros.fatAmount}g",
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 82, 82, 82),
                                            fontWeight: FontWeight.w100,
                                            fontSize: 12.0),
                                        ),
                                ],
                              ),
                                    LinearProgressIndicator(
                                    value: totalMacros.fatAmount / macroGoals.fatGoal,
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
                                                text: '${totalMacros.proteinAmount.toStringAsFixed(1)}g',
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
                                          "${macroGoals.proteinGoal - totalMacros.proteinAmount}g",
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 82, 82, 82),
                                            fontWeight: FontWeight.w100,
                                            fontSize: 12.0),
                                        ),
                                ],
                              ),
                                    LinearProgressIndicator(
                                    value: totalMacros.fatAmount / macroGoals.fatGoal,
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
            DiaryWidget(diaryName:'Breakfast'),
            DiaryWidget(diaryName:'Lunch'),
            DiaryWidget(diaryName:'Dinner'),
            DiaryWidget(diaryName:'Snacks'),
              ],
            );
          }
          ),
         backgroundColor: Theme.of(context).colorScheme.primary,
      );
  }
}

