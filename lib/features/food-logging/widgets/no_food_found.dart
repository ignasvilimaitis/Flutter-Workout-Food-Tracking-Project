import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoFoodFoundPopUp extends StatelessWidget {
  const NoFoodFoundPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: Column(
            children: [
                SvgPicture.asset(AppAssets.logging.missingFoodIcon,
                            height: 80,
                            width: 60,),
              SizedBox(height: 10,),
              Text("Hmm. We can't seem to find that.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Istok Web'
              ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: const Color.fromARGB(255, 247, 116, 116),
                ),
                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: TextButton(
                  style: ButtonStyle(
                  ),
                 onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.add,
                  size: 30,
                  color: Colors.white,
                  ),
                  const Text("Create Custom Food",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),),
                  ]
                )
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ],
    );
  }
}