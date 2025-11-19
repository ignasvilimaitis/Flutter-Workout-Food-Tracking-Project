import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/food-logging/widgets/big_plus_button.dart';
import 'package:flutter_application_1/features/food-logging/widgets/white_box.dart';

class DiaryFooter extends StatelessWidget {
  const DiaryFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
      child: 
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          WhiteBoxFooter(),
          WhiteBoxFooter(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            child: BigBlackPlusButton(),
          ),
          WhiteBoxFooter(),
          WhiteBoxFooter(),
      ],
      ),
    );
  }
}