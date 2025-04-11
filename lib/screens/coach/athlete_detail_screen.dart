import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../models/athlete.dart';
import '../../services/athlete_service.dart';
import '../../config/theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class AthleteDetailScreen extends StatefulWidget {
  const AthleteDetailScreen({super.key});

  @override
  _AthleteDetailScreenState createState() => _AthleteDetailScreenState();
}

class _AthleteDetailScreenState extends State<AthleteDetailScreen> with SingleTickerProviderStateMixin {
  late Athlete athlete;
  bool _isLoading = true;
  late TabController _tabController;
  
  // For the map
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = {};
  
  // For auto-refresh of vitals
  Timer? _refreshTimer;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Set up auto-refresh every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _refreshAthleteData();
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get athlete data from arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('athlete')) {
      athlete = args['athlete'] as Athlete;
      setState(() {
        _isLoading = false;
      });
      _setupMap();
    } else {
      // Handle case where no athlete was passed
      Navigator.pop(context);
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }
  
  // Refresh athlete data
  Future<void> _refreshAthleteData() async {
    if (!mounted) return;
    
    try {
      final updatedAthlete = await AthleteService.getAthleteById(athlete.id);
      if (updatedAthlete != null && mounted) {
        setState(() {
          athlete = updatedAthlete;
        });
        _updateMap();
      }
    } catch (e) {
      // Handle error
      print('Error refreshing athlete data: $e');
    }
  }
  
  // Set up the map
  void _setupMap() {
    if (athlete.latitude == null || athlete.longitude == null) return;
    
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId(athlete.id),
          position: LatLng(athlete.latitude!, athlete.longitude!),
          infoWindow: InfoWindow(title: athlete.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      };
    });
  }
  
  // Update map markers
  void _updateMap() {
    if (athlete.latitude == null || athlete.longitude == null) return;
    
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId(athlete.id),
          position: LatLng(athlete.latitude!, athlete.longitude!),
          infoWindow: InfoWindow(title: athlete.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      };
    });
    
    // Animate camera to updated position
    if (_mapController.isCompleted && athlete.status != 'offline') {
      _mapController.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newLatLng(LatLng(athlete.latitude!, athlete.longitude!)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Détails de l\'athlète'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: accentColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  athlete.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: accentColor,
                    ),
                    Positioned(
                      right: -50,
                      bottom: -10,
                      child: Icon(
                        Icons.directions_run,
                        size: 180,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 60,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Text(
                              athlete.name.substring(0, 1),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(athlete.status).withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  _getStatusText(athlete.status),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                athlete.sport,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(text: 'Général'),
                  Tab(text: 'Localisation'),
                  Tab(text: 'Historique'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildLocationTab(),
            _buildHistoryTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.chat),
        onPressed: () {
          // Open chat with athlete
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fonctionnalité de chat à implémenter'),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _refreshAthleteData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vital signs
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Signes vitaux',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Mis à jour ${athlete.lastActive}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Heart rate
                    _buildVitalRow(
                      Icons.favorite,
                      'Fréquence cardiaque',
                      athlete.status == 'offline' ? '-- bpm' : '${athlete.heartRate} bpm',
                      athlete.status == 'offline' ? Colors.grey : (athlete.heartRate > 100 ? errorColor : successColor),
                    ),
                    
                    const Divider(height: 32),
                    
                    // Temperature
                    _buildVitalRow(
                      Icons.thermostat,
                      'Température',
                      athlete.status == 'offline' ? '-- °C' : '${athlete.temperature.toStringAsFixed(1)} °C',
                      athlete.status == 'offline' ? Colors.grey : (athlete.temperature > 38 ? warningColor : successColor),
                    ),
                    
                    if (athlete.status == 'offline')
                      Container(
                        margin: const EdgeInsets.only(top: 24),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'L\'athlète est hors ligne. Les données ne sont pas disponibles.',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Performance metrics
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performances récentes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                                    return Text(
                                      days[value.toInt()],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                                reservedSize: 30,
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 2.5),
                                FlSpot(1, 3.1),
                                FlSpot(2, 4.0),
                                FlSpot(3, 3.2),
                                FlSpot(4, 4.3),
                                FlSpot(5, 5.5),
                                FlSpot(6, 4.8),
                              ],
                              isCurved: true,
                              color: primaryColor,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: primaryColor.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Distance parcourue (km)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Session stats
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistiques',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Distance', '24.6 km', Icons.straighten),
                        _buildStatItem('Calories', '3,250 kcal', Icons.local_fire_department),
                        _buildStatItem('Temps', '3h 15m', Icons.timer),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    
                    Text(
                      'Cette semaine',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLocationTab() {
    if (athlete.status == 'offline' || athlete.latitude == null || athlete.longitude == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Localisation non disponible',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'L\'athlète est hors ligne ou n\'a pas partagé sa position.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(athlete.latitude!, athlete.longitude!),
              zoom: 15,
            ),
            markers: _markers,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Position actuelle',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Lat: ${athlete.latitude!.toStringAsFixed(6)}, Long: ${athlete.longitude!.toStringAsFixed(6)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/gps_map',
                        arguments: {'initialPosition': LatLng(athlete.latitude!, athlete.longitude!)},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('Suivre'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildHistoryTab() {
    // Sample session data
    final sessions = [
      {
        'date': '24 mars 2023',
        'duration': '45 min',
        'distance': '5.2 km',
        'type': 'Course à pied',
      },
      {
        'date': '22 mars 2023',
        'duration': '1h 10min',
        'distance': '8.4 km',
        'type': 'Course à pied',
      },
      {
        'date': '20 mars 2023',
        'duration': '30 min',
        'distance': '3.7 km',
        'type': 'Course à pied',
      },
      {
        'date': '18 mars 2023',
        'duration': '50 min',
        'distance': '6.1 km',
        'type': 'Course à pied',
      },
    ];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_run,
                color: primaryColor,
              ),
            ),
            title: Text(
              session['type']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(session['date']!),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.straighten,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(session['distance']!),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(session['duration']!),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                // View session details
              },
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildVitalRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
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
  
  String _getStatusText(String status) {
    switch (status) {
      case 'online':
        return 'En ligne';
      case 'training':
        return 'Entraînement';
      case 'resting':
        return 'Repos';
      case 'offline':
        return 'Hors ligne';
      case 'alert':
        return 'Alerte';
      default:
        return 'Inconnu';
    }
  }
}