import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AthleteDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? athleteData;

  const AthleteDetailScreen({super.key, this.athleteData});

  @override
  _AthleteDetailScreenState createState() => _AthleteDetailScreenState();
}

class _AthleteDetailScreenState extends State<AthleteDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _notificationsEnabled = true;
  String _selectedTimeframe = 'Aujourd\'hui';
  final List<String> _timeframes = ['Aujourd\'hui', 'Cette semaine', 'Ce mois', 'Cette année'];
  
  // Sample training data
  final List<Map<String, dynamic>> _trainingSessions = [
    {
      'date': DateTime.now().subtract(const Duration(days: 0, hours: 3)),
      'duration': 65, // minutes
      'type': 'Entraînement intensif',
      'maxHeartRate': 175,
      'avgHeartRate': 145,
      'maxSpeed': 22.4,
      'distance': 8.5,
      'calories': 740,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'duration': 45, // minutes
      'type': 'Récupération',
      'maxHeartRate': 140,
      'avgHeartRate': 125,
      'maxSpeed': 15.8,
      'distance': 5.2,
      'calories': 390,
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'duration': 90, // minutes
      'type': 'Endurance',
      'maxHeartRate': 162,
      'avgHeartRate': 138,
      'maxSpeed': 19.5,
      'distance': 12.8,
      'calories': 920,
    },
  ];
  
  // Sample vital signs data for charts
  final List<Map<String, dynamic>> _heartRateData = List.generate(24, (index) {
    // Simulate a heart rate pattern throughout the day
    double baseRate = 65;
    double variation;
    
    if (index >= 6 && index <= 10) {  // Morning workout
      variation = 60 + (index - 6) * 10;
    } else if (index >= 16 && index <= 19) {  // Evening workout
      variation = 40 + (index - 16) * 15;
    } else if (index >= 22 || index <= 4) {  // Sleep
      variation = -15;
    } else {
      variation = 10 + (index % 3) * 5;
    }
    
    return {
      'time': index,
      'value': (baseRate + variation + (index % 5) * 2).round(),
    };
  });
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use provided athlete data or a default
    final athlete = widget.athleteData ?? {
      'name': 'Marie Laurent',
      'sport': 'Basketball',
      'age': 23,
      'weight': 68,  // kg
      'height': 178, // cm
      'status': 'training',
      'heartRate': 125,
      'temperature': 38.1,
      'speed': 12.3,
      'distance': 5.2,
      'calories': 420,
      'lastActive': '23 mars, 09:45',
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(athlete['name']),
        actions: [
          IconButton(
            icon: Icon(
              _notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
              color: _notificationsEnabled ? Colors.white : Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _notificationsEnabled = !_notificationsEnabled;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _notificationsEnabled 
                        ? 'Notifications activées pour ${athlete['name']}' 
                        : 'Notifications désactivées pour ${athlete['name']}',
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'message') {
                // Open messaging
              } else if (value == 'edit') {
                // Edit athlete profile
              } else if (value == 'export') {
                // Export data
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'message',
                child: Row(
                  children: [
                    Icon(Icons.message, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Envoyer un message'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Modifier le profil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Exporter les données'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Aperçu'),
            Tab(text: 'Entraînements'),
            Tab(text: 'Statistiques'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(context, athlete),
          _buildTrainingsTab(context),
          _buildStatsTab(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Create new training plan
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        icon: const Icon(Icons.add),
        label: const Text('Plan d\'entraînement'),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, Map<String, dynamic> athlete) {
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Athlete Header Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        child: Text(
                          athlete['name'].substring(0, 1),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  athlete['name'],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        statusText,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              athlete['sport'],
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _athleteInfoItem(
                                  icon: Icons.calendar_today,
                                  label: 'Âge',
                                  value: '${athlete['age']} ans',
                                ),
                                _athleteInfoItem(
                                  icon: Icons.height,
                                  label: 'Taille',
                                  value: '${athlete['height']} cm',
                                ),
                                _athleteInfoItem(
                                  icon: Icons.fitness_center,
                                  label: 'Poids',
                                  value: '${athlete['weight']} kg',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          
          // Current Activity
          if (athlete['status'] == 'training')
            _buildCurrentActivityCard(context, athlete),

          const SizedBox(height: 24),
          
          // Vital Signs
          Text(
            'Signes vitaux',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildVitalCard(
                  context,
                  icon: Icons.favorite,
                  label: 'Rythme cardiaque',
                  value: '${athlete['heartRate']}',
                  unit: 'bpm',
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildVitalCard(
                  context,
                  icon: Icons.thermostat,
                  label: 'Température',
                  value: '${athlete['temperature']}',
                  unit: '°C',
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Notes section
          Text(
            'Notes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notes personnelles',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          // Edit notes
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Athlète très motivée. A amélioré son endurance sur les dernières semaines. À surveiller : léger inconfort au niveau du genou gauche après les séances longues.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Recent Training section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Entraînements récents',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  _tabController.animateTo(1); // Switch to training tab
                },
                child: Text(
                  'Voir tous',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecentTrainings(),
        ],
      ),
    );
  }

  Widget _athleteInfoItem({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentActivityCard(BuildContext context, Map<String, dynamic> athlete) {
    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activité en cours',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricColumn(
                  icon: Icons.speed,
                  value: '${athlete['speed']}',
                  unit: 'km/h',
                  label: 'Vitesse',
                ),
                _buildMetricColumn(
                  icon: Icons.straighten,
                  value: '${athlete['distance']}',
                  unit: 'km',
                  label: 'Distance',
                ),
                _buildMetricColumn(
                  icon: Icons.local_fire_department,
                  value: '${athlete['calories']}',
                  unit: 'kcal',
                  label: 'Calories',
                ),
                _buildMetricColumn(
                  icon: Icons.timer,
                  value: '45:22',
                  unit: '',
                  label: 'Durée',
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // View live activity details
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
                side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Center(
                child: Text('Voir l\'activité en direct'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn({
    required IconData icon, 
    required String value, 
    required String unit, 
    required String label
  }) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 8),
        Text(
          unit.isNotEmpty ? '$value $unit' : value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVitalCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '$value $unit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dernière mise à jour il y a 5 minutes',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTrainings() {
    return Column(
      children: _trainingSessions.take(2).map((session) {
        final date = session['date'] as DateTime;
        final formattedDate = DateFormat('dd MMM, HH:mm').format(date);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      session['type'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTrainingMetric(
                      icon: Icons.timer,
                      value: '${session['duration']} min',
                      label: 'Durée',
                    ),
                    _buildTrainingMetric(
                      icon: Icons.straighten,
                      value: '${session['distance']} km',
                      label: 'Distance',
                    ),
                    _buildTrainingMetric(
                      icon: Icons.favorite,
                      value: '${session['avgHeartRate']} bpm',
                      label: 'FC Moy',
                    ),
                    _buildTrainingMetric(
                      icon: Icons.local_fire_department,
                      value: '${session['calories']} kcal',
                      label: 'Calories',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrainingMetric({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingsTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter options
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.filter_list, color: Colors.grey),
                const SizedBox(width: 8),
                const Text('Période:'),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedTimeframe,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: _timeframes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedTimeframe = newValue;
                        });
                      }
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Create new training session
                  },
                  child: Text(
                    'Ajouter',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Training sessions list
          Expanded(
            child: ListView.builder(
              itemCount: _trainingSessions.length,
              itemBuilder: (context, index) {
                final session = _trainingSessions[index];
                final date = session['date'] as DateTime;
                final formattedDate = DateFormat('dd MMMM yyyy, HH:mm').format(date);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getTrainingIcon(session['type']),
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session['type'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                // Show options
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTrainingDetailMetric(
                              icon: Icons.timer,
                              value: '${session['duration']}',
                              unit: 'min',
                              label: 'Durée',
                            ),
                            _buildTrainingDetailMetric(
                              icon: Icons.straighten,
                              value: '${session['distance']}',
                              unit: 'km',
                              label: 'Distance',
                            ),
                            _buildTrainingDetailMetric(
                              icon: Icons.speed,
                              value: '${session['maxSpeed']}',
                              unit: 'km/h',
                              label: 'Vitesse max',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTrainingDetailMetric(
                              icon: Icons.favorite,
                              value: '${session['avgHeartRate']}',
                              unit: 'bpm',
                              label: 'FC moyenne',
                            ),
                            _buildTrainingDetailMetric(
                              icon: Icons.favorite_border,
                              value: '${session['maxHeartRate']}',
                              unit: 'bpm',
                              label: 'FC max',
                            ),
                            _buildTrainingDetailMetric(
                              icon: Icons.local_fire_department,
                              value: '${session['calories']}',
                              unit: 'kcal',
                              label: 'Calories',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                            // View detailed training session
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Text('Voir tous les détails'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTrainingIcon(String type) {
    switch (type.toLowerCase()) {
      case 'endurance':
        return Icons.directions_run;
      case 'récupération':
        return Icons.self_improvement;
      case 'entraînement intensif':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
  }

  Widget _buildTrainingDetailMetric({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time frame selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.date_range, color: Colors.grey),
                const SizedBox(width: 8),
                const Text('Période:'),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedTimeframe,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: _timeframes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedTimeframe = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats cards
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 24),
                  
                  // Heart Rate Graph
                  Text(
                    'Rythme cardiaque',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildHeartRateGraph(),
                  const SizedBox(height: 24),
                  
                  // Performance Metrics
                  Text(
                    'Métriques de performance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildPerformanceMetrics(),
                  const SizedBox(height: 24),
                  
                  // Fitness Progress
                  Text(
                    'Progression',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildProgressMetrics(),
                  const SizedBox(height: 32),
                  
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        // Export stats data
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download),
                          SizedBox(width: 8),
                          Text('Exporter les statistiques'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Résumé ${_selectedTimeframe.toLowerCase()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryMetric(
                  icon: Icons.directions_run,
                  value: '3',
                  unit: '',
                  label: 'Entraînements',
                ),
                _buildSummaryMetric(
                  icon: Icons.timer,
                  value: '3.5',
                  unit: 'h',
                  label: 'Durée totale',
                ),
                _buildSummaryMetric(
                  icon: Icons.straighten,
                  value: '26.5',
                  unit: 'km',
                  label: 'Distance',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryMetric(
                  icon: Icons.local_fire_department,
                  value: '2050',
                  unit: 'kcal',
                  label: 'Calories',
                ),
                _buildSummaryMetric(
                  icon: Icons.favorite,
                  value: '142',
                  unit: 'bpm',
                  label: 'FC moyenne',
                ),
                _buildSummaryMetric(
                  icon: Icons.speed,
                  value: '19.2',
                  unit: 'km/h',
                  label: 'Vitesse max',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryMetric({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: unit.isNotEmpty ? ' $unit' : '',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildHeartRateGraph() {
    // Placeholder for a heart rate graph
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aujourd\'hui',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Rythme cardiaque',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: HeartRateGraphPainter(
                  data: _heartRateData,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                size: const Size(double.infinity, 200),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('00:00', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text('06:00', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text('12:00', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text('18:00', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text('23:59', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeartRateMetric(label: 'Moyenne', value: '78 bpm'),
                _buildHeartRateMetric(label: 'Max', value: '165 bpm'),
                _buildHeartRateMetric(label: 'Min', value: '58 bpm'),
                _buildHeartRateMetric(label: 'Repos', value: '62 bpm'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeartRateMetric({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPerformanceMetrics() {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vitesse moyenne',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '12.8',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          'km/h',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '+0.7 km/h',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'vs semaine dernière',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Puissance moyenne',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '215',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          'watts',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '+12 watts',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'vs semaine dernière',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildProgressMetrics() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Objectifs hebdomadaires',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            _buildProgressBar(
              label: 'Distance',
              current: 26.5,
              target: 30,
              unit: 'km',
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildProgressBar(
              label: 'Séances',
              current: 3,
              target: 5,
              unit: '',
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildProgressBar(
              label: 'Calories',
              current: 2050,
              target: 3000,
              unit: 'kcal',
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            _buildProgressBar(
              label: 'Temps d\'activité',
              current: 210,
              target: 300,
              unit: 'min',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressBar({
    required String label,
    required double current,
    required double target,
    required String unit,
    required Color color,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);
    final formattedCurrent = current.toInt().toString();
    final formattedTarget = target.toInt().toString();
    final formattedUnit = unit.isNotEmpty ? ' $unit' : '';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$formattedCurrent/$formattedTarget$formattedUnit',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Custom painter for heart rate graph
class HeartRateGraphPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Color color;
  
  HeartRateGraphPainter({required this.data, required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
      
    final Paint fillPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    final double maxValue = data.map((e) => e['value'] as num).reduce((a, b) => a > b ? a : b).toDouble();
    const double minValue = 50; // Minimum heart rate to show
    
    final Path linePath = Path();
    final Path fillPath = Path();
    
    for (int i = 0; i < data.length; i++) {
      final double x = i * size.width / (data.length - 1);
      final double normalizedValue = (data[i]['value'] - minValue) / (maxValue - minValue);
      final double y = size.height - (normalizedValue * size.height);
      
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    
    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}