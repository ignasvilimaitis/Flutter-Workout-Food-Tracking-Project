import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme.dart';

class FoodTabBar extends StatefulWidget {
  final String text;
  final bool isSelected;
  
  const FoodTabBar({
    super.key,
    required this.text,
    required this.isSelected,});

  @override
  State<FoodTabBar> createState() => _FoodTabBarState();
}

class _FoodTabBarState extends State<FoodTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
                      width: 150,
                      height: 23,
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? getThemeData().primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: BoxBorder.all(
                          color: getThemeData().primaryColor,
                        ),
                      ),
                      child: Tab(
                        height: 20,
                        child: Text(
                          widget.text,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
  }
}