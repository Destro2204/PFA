import 'package:flutter/material.dart';

// Application colors - Updated with a modern professional palette
const Color primaryColor = Color(0xFF4361EE); // Modern blue primary
const Color accentColor = Color(0xFF3A0CA3); // Deep purple accent
const Color backgroundColor = Colors.white;
const Color lightBlueColor = Color(0xFFEDF2FB);
const Color lightPurpleColor = Color(0xFFF0EBFF);
const Color errorColor = Color(0xFFEF233C);
const Color successColor = Color(0xFF2B9348);
const Color warningColor = Color(0xFFFFC107);
const Color textColor = Color(0xFF2B2D42);
const Color textLightColor = Color(0xFF8D99AE);

// Application theme
final ThemeData appTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
    secondary: accentColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    surface: Colors.white,
    error: errorColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  textTheme: const TextTheme(
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
      color: textColor,
      fontSize: 16,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    titleLarge: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    titleMedium: TextStyle(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    bodyMedium: TextStyle(
      color: textColor,
      fontSize: 14,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: errorColor, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: errorColor, width: 2),
    ),
    labelStyle: TextStyle(color: Colors.grey[600]),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    floatingLabelBehavior: FloatingLabelBehavior.never,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: primaryColor, width: 2),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 5,
    shadowColor: Colors.black.withOpacity(0.2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.antiAlias,
  ),
  dividerTheme: const DividerThemeData(
    thickness: 1,
    space: 32,
    color: Color(0xFFEEEEEE),
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: textColor.withOpacity(0.9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentTextStyle: const TextStyle(color: Colors.white),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: primaryColor,
    unselectedItemColor: textLightColor,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    unselectedLabelStyle: TextStyle(fontSize: 12),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: accentColor,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
);

// Status colors for athlete monitoring
const Map<String, Color> statusColors = {
  'online': Color(0xFF2B9348),    // Green
  'training': Color(0xFF3A86FF),  // Blue
  'resting': Color(0xFFFFA420),   // Orange
  'offline': Color(0xFF8D99AE),   // Gray
  'alert': Color(0xFFEF233C),     // Red
};

// Helper method to get status color based on status string
Color getStatusColor(String status) {
  return statusColors[status] ?? Colors.grey;
}