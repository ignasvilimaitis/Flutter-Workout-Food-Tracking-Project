import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const UIButton(
    {super.key,
     required this.text,
     required this.onPressed,
     required this.icon
     }
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.075,
            width: MediaQuery.of(context).size.height * 0.515,
            margin: EdgeInsets.fromLTRB(
              8.0,
              0.0,
              8.0,
              15.0
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular((20.0)),
              border: Border.all(color: Colors.grey),
           ),
           child: Row(
             children: [
                Padding(
                  padding: EdgeInsetsGeometry.directional(
                    start: 10.0
                  ),
                ),
                Icon(icon),
                Padding(padding: EdgeInsetsGeometry.directional(
                  start: 8.0
                )),
                Text(text)

             ],
           ),
          ),
      ],
    );
  }
}