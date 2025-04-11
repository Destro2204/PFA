class Athlete {
  final String id;
  final String name;
  final String sport;
  final String lastActive;
  final String status; // 'online', 'training', 'offline', 'resting', 'alert'
  final int heartRate;
  final double temperature;
  final double? latitude;
  final double? longitude;
  final String? profileImage;
  final List<Map<String, dynamic>>? sessions;
  
  Athlete({
    required this.id,
    required this.name,
    required this.sport,
    required this.lastActive,
    required this.status,
    required this.heartRate,
    required this.temperature,
    this.latitude,
    this.longitude,
    this.profileImage,
    this.sessions,
  });
  
  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sport: json['sport'] ?? '',
      lastActive: json['lastActive'] ?? '',
      status: json['status'] ?? 'offline',
      heartRate: json['heartRate'] ?? 0,
      temperature: json['temperature']?.toDouble() ?? 0.0,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      profileImage: json['profileImage'],
      sessions: json['sessions'] != null 
          ? List<Map<String, dynamic>>.from(json['sessions']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sport': sport,
      'lastActive': lastActive,
      'status': status,
      'heartRate': heartRate,
      'temperature': temperature,
      'latitude': latitude,
      'longitude': longitude,
      'profileImage': profileImage,
      'sessions': sessions,
    };
  }
} 