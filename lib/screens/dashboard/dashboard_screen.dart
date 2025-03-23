import 'package:flutter/material.dart';
import '../../widgets/dashboard/heart_rate_widget.dart';
import '../../widgets/dashboard/temperature_widget.dart';
import '../../widgets/dashboard/data_analysis_widget.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String userName = "Utilisateur"; // Remplacer par les données réelles de l'utilisateur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('GPS Tracker Vest'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Fonctionnalité à implémenter
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Fonctionnalité à implémenter
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bonjour, $userName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Theme.of(context).primaryColor),
              title: const Text('Tableau de bord'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.map, color: Theme.of(context).primaryColor),
              title: const Text('Carte GPS'),
              onTap: () {
                Navigator.pop(context);
                // Naviguer vers la page de carte GPS
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Theme.of(context).primaryColor),
              title: const Text('Historique'),
              onTap: () {
                Navigator.pop(context);
                // Naviguer vers la page d'historique
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                // Naviguer vers la page de paramètres
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bienvenue
                Text(
                  'Bienvenue, $userName',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Voici les données de votre veste GPS',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Widgets principaux
                Row(
                  children: [
                    Expanded(
                      child: HeartRateWidget(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TemperatureWidget(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Widget d'analyse de données
                DataAnalysisWidget(),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}