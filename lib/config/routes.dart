import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/registration_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/role/role_selection_screen.dart';
import '../screens/coach/coach_dashboard_screen.dart';
import '../screens/coach/athlete_detail_screen.dart';
import '../screens/dashboard/gps_map_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => RoleSelectionScreen(),
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegistrationScreen(),
  '/dashboard': (context) => DashboardScreen(),
  '/coach_dashboard': (context) => CoachDashboardScreen(),
  '/athlete_detail': (context) => AthleteDetailScreen(),
  '/gps_map': (context) => GPSMapScreen(),
};