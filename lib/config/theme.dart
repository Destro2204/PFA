import 'package:flutter/material.dart';

// Couleurs de l'application
final Color primaryColor = const Color(0xFF001F3F); // Bleu marine
final Color backgroundColor = Colors.white;
final Color accentColor = const Color(0xFF4169E1);
final Color dangerColor = Colors.red;

// Thème de l'application
final ThemeData appTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 28,
    ),
    displayMedium: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    bodyLarge: TextStyle(
      color: primaryColor,
      fontSize: 16,
    ),
    labelLarge: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: accentColor, width: 2),
    ),
    labelStyle: TextStyle(color: primaryColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
);