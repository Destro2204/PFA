import 'package:flutter/material.dart';

// Couleurs de l'application
class AppColors {
  static const Color primary = Color(0xFF001F3F); // Bleu marine
  static const Color background = Colors.white;
  static const Color accent = Color(0xFF4169E1);
  static const Color danger = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;
}

// Textes de l'application
class AppStrings {
  static const String appName = 'GPS Tracker Vest';
  static const String loginTitle = 'Connexion';
  static const String registerTitle = 'Inscription';
  static const String welcomeMessage = 'Bienvenue sur GPS Tracker Vest';
  static const String dashboardTitle = 'Tableau de bord';
}

// Valeurs de référence pour les capteurs
class SensorReferences {
  static const double minNormalTemperature = 36.0;
  static const double maxNormalTemperature = 37.5;
  static const double minNormalHeartRate = 60.0;
  static const double maxNormalHeartRate = 100.0;
}

// Paramètres de l'application
class AppSettings {
  static const Duration dataRefreshInterval = Duration(seconds: 2);
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const int maxDataPoints = 100; // Pour les graphiques historiques
}

// Routes nommées
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String map = '/map';
  static const String history = '/history';
}