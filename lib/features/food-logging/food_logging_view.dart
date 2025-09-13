import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/states/states.dart';
import 'package:flutter_application_1/features/food-logging/widgets/diary_widget.dart';
import 'package:flutter_application_1/features/food-logging/widgets/diary_widget_v2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

DateTime date = DateTime.now();
String today = '${date.day}th ${DateFormat('MMMM').format(date)} ${date.year}';

class FoodLoggingView extends StatefulWidget {

  const FoodLoggingView({super.key});
  

  @override
  State<FoodLoggingView> createState() => _FoodLoggingViewState();
}

class _FoodLoggingViewState extends State<FoodLoggingView> {
  late PageController _pageController;
  late TabController _tabController;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // _tabController = TabController(length: 4, vsync: ScrollableState());
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    // _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<TotalMacros, MacroGoal>(
          builder: (context, totalMacros, macroGoals, child) {
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
                      width: 330,
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
                        SizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text(
                            today,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                        ),
                        SizedBox(width: 20),
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
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[ 
                         PageView(
                          controller: _pageController,
                          children: <Widget> [
                            Container(
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
                                                "${(macroGoals.carbGoal - totalMacros.carbAmount).toStringAsFixed(1)}g",
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
                                                "${(macroGoals.fatGoal - totalMacros.fatAmount).toStringAsFixed(1)}g",
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
                                                "${(macroGoals.proteinGoal - totalMacros.proteinAmount).toStringAsFixed(1)}g",
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
                            const Text("Page 2"),
                            const Text("Page 3"),
                            const Text("Page 4"),
                            const Text("Page 5"),
                                                          
                          ]
                        ),
                        SmoothPageIndicator(
                     controller: _pageController,
                     count: 5,
                     ),
                     
                     
                        ]
                      ),
                    ),
                    ]
              ),  
            Padding(padding: EdgeInsetsGeometry.only(top: 15)
                  ),
            Column(
              children: [
                Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular((20.0)),
                        color: Colors.white,
                      ),
                  width:MediaQuery.of(context).size.width * 0.97,
                  child: Column(
                    children: [
                      const Text ("Log"),
                      DiaryWidgetV2(diaryName: "Breakfast",),
                    ],
                  )),
              ],
            ),

              ],
            );
          }
          ),
         backgroundColor: Theme.of(context).colorScheme.primary,
      );
  }
}

