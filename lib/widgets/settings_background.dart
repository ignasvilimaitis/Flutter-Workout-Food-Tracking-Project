import 'package:flutter/material.dart';

class SettingsUIBackground extends StatelessWidget {
  const SettingsUIBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        margin: EdgeInsets.fromLTRB(
          8.0,
          24.0,
          8.0,
          15.0
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((16.0)),
          color: Colors.white,
        ),
        child: child,
      ),
      backgroundColor: Colors.grey,

    );
  }
}