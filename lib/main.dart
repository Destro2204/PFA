import 'package:flutter/material.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Tracker Vest',
      theme: appTheme,
      routes: appRoutes,
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}