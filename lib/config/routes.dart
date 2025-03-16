import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/registration_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegistrationScreen(),
  '/dashboard': (context) => DashboardScreen(),
};