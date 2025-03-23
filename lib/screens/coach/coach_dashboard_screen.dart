  import 'package:flutter/material.dart';

class CoachDashboardScreen extends StatefulWidget {
  @override
  _CoachDashboardScreenState createState() => _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends State<CoachDashboardScreen> {
  final String coachName = "Coach"; // Replace with actual coach data
  List<Map<String, dynamic>> athletes = [
    {
      'name': 'Thomas Dubois',
      'sport': 'Football',
      'lastActive': '23 mars, 10:30',
      'status': 'online',
      'heartRate': 72,
      'temperature': 37.2,
    },
    {
      'name': 'Marie Laurent',
      'sport': 'Basketball',
      'lastActive': '23 mars, 09:45',
      'status': 'training',
      'heartRate': 125,
      'temperature': 38.1,
    },
    {
      'name': 'Lucas Petit',
      'sport': 'Rugby',
      'lastActive': '22 mars, 18:20',
      'status': 'offline',
      'heartRate': 0,
      'temperature': 0,
    },
    {
      'name': 'Sophie Martin',
      'sport': 'Athlétisme',
      'lastActive': '23 mars, 08:15',
      'status': 'resting',
      'heartRate': 65,
      'temperature': 36.8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Coach Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Functionality to implement
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Functionality to implement
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
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.assignment_ind,
                      size: 40,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bonjour, $coachName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Theme.of(context).colorScheme.secondary),
              title: const Text('Tableau de bord'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: Theme.of(context).colorScheme.secondary),
              title: const Text('Mes athlètes'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to athletes page
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.secondary),
              title: const Text('Calendrier'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to calendar page
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart, color: Theme.of(context).colorScheme.secondary),
              title: const Text('Rapports'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to reports page
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings page
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.secondary),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Text(
                'Bonjour, $coachName',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Suivez les performances de vos athlètes',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              
              // Quick stats
              Row(
                children: [
                  _buildStatCard(
                    context,
                    title: 'Athlètes',
                    value: '${athletes.length}',
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    title: 'Actifs',
                    value: '${athletes.where((a) => a['status'] != 'offline').length}',
                    icon: Icons.fitness_center,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    title: 'En entraînement',
                    value: '${athletes.where((a) => a['status'] == 'training').length}',
                    icon: Icons.directions_run,
                    color: Colors.orange,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Athletes section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mes athlètes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to full athletes list
                    },
                    icon: Icon(
                      Icons.people,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(
                      'Voir tous',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Athletes list
              Expanded(
                child: ListView.builder(
                  itemCount: athletes.length,
                  itemBuilder: (context, index) {
                    final athlete = athletes[index];
                    return _buildAthleteCard(context, athlete);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
        onPressed: () {
          // Add new athlete functionality
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAthleteCard(BuildContext context, Map<String, dynamic> athlete) {
    Color statusColor;
    String statusText;
    
    switch (athlete['status']) {
      case 'online':
        statusColor = Colors.green;
        statusText = 'En ligne';
        break;
      case 'training':
        statusColor = Colors.orange;
        statusText = 'Entraînement';
        break;
      case 'resting':
        statusColor = Colors.blue;
        statusText = 'Repos';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Hors ligne';
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  child: Text(
                    athlete['name'].substring(0, 1),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        athlete['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        athlete['sport'],
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (athlete['status'] != 'offline') ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildVitalSign(
                    context,
                    icon: Icons.favorite,
                    label: 'Rythme cardiaque',
                    value: '${athlete['heartRate']}',
                    unit: 'bpm',
                    color: Colors.red,
                  ),
                  _buildVitalSign(
                    context,
                    icon: Icons.thermostat,
                    label: 'Température',
                    value: '${athlete['temperature']}',
                    unit: '°C',
                    color: Colors.orange,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dernière activité: ${athlete['lastActive']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to athlete detail
                  },
                  child: Text(
                    'Voir détails',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSign(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$value $unit',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}