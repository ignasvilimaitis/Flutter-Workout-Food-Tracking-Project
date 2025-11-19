import 'package:flutter/material.dart';

ThemeData getThemeData(){
  return ThemeData(

    primaryColor: Color.fromRGBO(218, 218, 218, 1),
    cardColor: Colors.white,
    fontFamily: 'Inter',

    colorScheme: ColorScheme.light(
      primary: Color.fromRGBO(218, 218, 218, 1),
      secondary: Color.fromRGBO(48, 48, 48, 0.6),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      )
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  );
}