import '../models/athlete.dart';
import 'dart:math';
import 'dart:async';

class AthleteService {
  // For the MVP, using a simple simulation
  // In a real app, this would connect to an API or Firebase
  
  static final Random _random = Random();
  
  // Simulated list of athletes
  static final List<Athlete> _athletes = [
    Athlete(
      id: '1',
      name: 'Thomas Dubois',
      sport: 'Football',
      lastActive: '23 mars, 10:30',
      status: 'online',
      heartRate: 72,
      temperature: 37.2,
      latitude: 48.85837 + _randomOffset(),
      longitude: 2.294481 + _randomOffset(),
    ),
    Athlete(
      id: '2',
      name: 'Marie Laurent',
      sport: 'Basketball',
      lastActive: '23 mars, 09:45',
      status: 'training',
      heartRate: 125,
      temperature: 38.1,
      latitude: 48.86024 + _randomOffset(),
      longitude: 2.292940 + _randomOffset(),
    ),
    Athlete(
      id: '3',
      name: 'Lucas Petit',
      sport: 'Rugby',
      lastActive: '22 mars, 18:20',
      status: 'offline',
      heartRate: 0,
      temperature: 0,
    ),
    Athlete(
      id: '4',
      name: 'Sophie Martin',
      sport: 'Athlétisme',
      lastActive: '23 mars, 08:15',
      status: 'resting',
      heartRate: 65,
      temperature: 36.8,
      latitude: 48.85584 + _randomOffset(),
      longitude: 2.297285 + _randomOffset(),
    ),
    Athlete(
      id: '5',
      name: 'Antoine Girard',
      sport: 'Natation',
      lastActive: '23 mars, 09:30',
      status: 'training',
      heartRate: 145,
      temperature: 38.3,
      latitude: 48.85894 + _randomOffset(),
      longitude: 2.291865 + _randomOffset(),
    ),
    Athlete(
      id: '6',
      name: 'Julie Leroux',
      sport: 'Tennis',
      lastActive: '23 mars, 11:10',
      status: 'online',
      heartRate: 78,
      temperature: 37.0,
      latitude: 48.86340 + _randomOffset(),
      longitude: 2.295215 + _randomOffset(),
    ),
  ];
  
  // Get random offset for simulating movement
  static double _randomOffset() {
    return (_random.nextDouble() - 0.5) * 0.01;
  }
  
  // Get heart rate with some randomness
  static int _getHeartRate(String status) {
    switch (status) {
      case 'training':
        return 120 + _random.nextInt(40);
      case 'resting':
        return 60 + _random.nextInt(15);
      case 'online':
        return 70 + _random.nextInt(20);
      default:
        return 0;
    }
  }
  
  // Get all athletes
  static Future<List<Athlete>> getAthletes() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simulate updating athlete vitals
    final updatedAthletes = _athletes.map((athlete) {
      if (athlete.status != 'offline') {
        return Athlete(
          id: athlete.id,
          name: athlete.name,
          sport: athlete.sport,
          lastActive: athlete.lastActive,
          status: athlete.status,
          heartRate: _getHeartRate(athlete.status),
          temperature: athlete.temperature + (_random.nextDouble() - 0.5) * 0.3,
          latitude: athlete.latitude != null ? athlete.latitude! + _randomOffset() : null,
          longitude: athlete.longitude != null ? athlete.longitude! + _randomOffset() : null,
          profileImage: athlete.profileImage,
          sessions: athlete.sessions,
        );
      }
      return athlete;
    }).toList();
    
    return updatedAthletes;
  }
  
  // Get athlete by ID
  static Future<Athlete?> getAthleteById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Find athlete by ID
    final athlete = _athletes.firstWhere(
      (a) => a.id == id,
      orElse: () => _athletes[0], // Just for MVP
    );
    
    if (athlete.status != 'offline') {
      return Athlete(
        id: athlete.id,
        name: athlete.name,
        sport: athlete.sport,
        lastActive: athlete.lastActive,
        status: athlete.status,
        heartRate: _getHeartRate(athlete.status),
        temperature: athlete.temperature + (_random.nextDouble() - 0.5) * 0.3,
        latitude: athlete.latitude != null ? athlete.latitude! + _randomOffset() : null,
        longitude: athlete.longitude != null ? athlete.longitude! + _randomOffset() : null,
        profileImage: athlete.profileImage,
        sessions: athlete.sessions,
      );
    }
    
    return athlete;
  }
  
  // Add a new athlete
  static Future<bool> addAthlete(Athlete athlete) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // In a real app, this would send to backend
    _athletes.add(athlete);
    return true;
  }
} 