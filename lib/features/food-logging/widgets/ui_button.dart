import 'package:flutter/material.dart';

class UIButton extends StatelessWidget {
  final IconData iconData;
  final String function;
  const UIButton({super.key, required this.iconData, required this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((16.0)),
        color: Colors.white,
      ),
      child: IconButton(
        onPressed: () {
          switch(function) {
            case "Return":
            Navigator.pop(context);
          }
        },
        icon: Icon(iconData),
      ),
    );
  }
}
