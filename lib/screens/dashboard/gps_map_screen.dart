import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';

class GPSMapScreen extends StatefulWidget {
  const GPSMapScreen({super.key});

  @override
  _GPSMapScreenState createState() => _GPSMapScreenState();
}

class _GPSMapScreenState extends State<GPSMapScreen> with WidgetsBindingObserver {
  // Controller for Google Maps
  final Completer<GoogleMapController> _controller = Completer();
  
  // Current camera position
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.0,
  );

  // User's current position
  Position? _currentPosition;
  
  // Markers to show on the map
  final Set<Marker> _markers = {};
  
  // Polylines to show route
  final Map<PolylineId, Polyline> _polylines = {};
  
  // List of recorded positions (for tracking)
  final List<LatLng> _recordedPositions = [];
  
  // Track recording state
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isFollowingUser = true;
  bool _isMapReady = false;
  
  // Timer for regular position updates
  Timer? _locationTimer;
  
  // Distance covered (in meters)
  double _distanceCovered = 0;
  
  // Time elapsed (in seconds)
  int _timeElapsed = 0;
  Timer? _timeTimer;
  
  // Speed statistics
  double _currentSpeed = 0;
  double _averageSpeed = 0;
  double _maxSpeed = 0;
  
  // Session metrics
  DateTime? _sessionStartTime;
  int _caloriesBurned = 0;
  final double _userWeight = 70; // kg - could be customizable in settings
  
  // Map type
  MapType _currentMapType = MapType.normal;
  
  // Tracking intervals
  int _trackingInterval = 5; // seconds

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLocationPermission();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App resumed from background, check if tracking
      if (_isRecording && !_isPaused) {
        _resumeTracking();
      }
    } else if (state == AppLifecycleState.paused) {
      // App went to background
      if (_isRecording && !_isPaused) {
        // Pause to save battery but don't change tracking state
        _pauseTimers();
      }
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _timeTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Check and request location permissions
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled. Please enable them to use this feature.');
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permissions are denied. Please enable them to use this feature.');
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _showSnackBar(
        'Location permissions are permanently denied. Please enable them in your device settings.',
      );
      return;
    }

    // Get current position
    _getCurrentLocation();
  }

  // Get current location and update the map
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = position;
        _initialCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        );
        
        // Add marker for current position
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'My Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );
      });
      
      // Move camera to current position
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
      setState(() {
        _isMapReady = true;
      });
    } catch (e) {
      print('Error getting location: $e');
      _showSnackBar('Failed to get current location. Please check your location settings.');
    }
  }

  // Start recording route
  void _startRecording() {
    setState(() {
      _isRecording = true;
      _isPaused = false;
      _recordedPositions.clear();
      _distanceCovered = 0;
      _timeElapsed = 0;
      _currentSpeed = 0;
      _averageSpeed = 0;
      _maxSpeed = 0;
      _sessionStartTime = DateTime.now();
      _caloriesBurned = 0;
      
      if (_currentPosition != null) {
        _recordedPositions.add(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        );
      }
    });
    
    // Start timer for position updates
    _locationTimer = Timer.periodic(Duration(seconds: _trackingInterval), (timer) {
      _updateLocation();
    });
    
    // Start timer for elapsed time
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
        _updateCaloriesBurned();
      });
    });
  }

  // Pause recording route
  void _pauseRecording() {
    setState(() {
      _isPaused = true;
    });
    _pauseTimers();
  }
  
  // Resume recording
  void _resumeRecording() {
    setState(() {
      _isPaused = false;
    });
    _resumeTracking();
  }

  // Stop recording route
  void _stopRecording() {
    _pauseTimers();
    
    setState(() {
      _isRecording = false;
      _isPaused = false;
    });
    
    // Show summary dialog
    if (_recordedPositions.length > 1) {
      _showSummaryDialog();
    }
  }
  
  // Pause timers
  void _pauseTimers() {
    _locationTimer?.cancel();
    _timeTimer?.cancel();
  }
  
  // Resume tracking
  void _resumeTracking() {
    // Start timer for position updates
    _locationTimer = Timer.periodic(Duration(seconds: _trackingInterval), (timer) {
      _updateLocation();
    });
    
    // Start timer for elapsed time
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
        _updateCaloriesBurned();
      });
    });
  }

  // Update location and add to recorded positions
  Future<void> _updateLocation() async {
    if (!_isRecording || _isPaused) return;
    
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        // Calculate distance from last point
        if (_recordedPositions.isNotEmpty && _currentPosition != null) {
          double distance = Geolocator.distanceBetween(
            _recordedPositions.last.latitude,
            _recordedPositions.last.longitude,
            position.latitude,
            position.longitude,
          );
          
          if (distance > 2) { // Filter out small movements (GPS drift)
            _distanceCovered += distance;
            
            // Calculate current speed in km/h
            _currentSpeed = (position.speed * 3.6); // m/s to km/h
            if (_currentSpeed > _maxSpeed) {
              _maxSpeed = _currentSpeed;
            }
            
            // Calculate average speed
            if (_timeElapsed > 0) {
              _averageSpeed = (_distanceCovered / 1000) / (_timeElapsed / 3600);
            }
          }
        }
        
        _currentPosition = position;
        LatLng newPosition = LatLng(position.latitude, position.longitude);
        
        // Only add point if we've moved a significant distance
        if (_recordedPositions.isEmpty || Geolocator.distanceBetween(
          _recordedPositions.last.latitude,
          _recordedPositions.last.longitude,
          newPosition.latitude,
          newPosition.longitude,
        ) > 2) {
          _recordedPositions.add(newPosition);
        }
        
        // Update current location marker
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: newPosition,
            infoWindow: const InfoWindow(title: 'My Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        );
        
        // Update polyline
        _updatePolylines();
      });
      
      // Move camera to current position if following is enabled
      if (_isFollowingUser) {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        );
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  // Update polylines on the map
  void _updatePolylines() {
    if (_recordedPositions.length < 2) return;
    
    PolylineId id = const PolylineId('route');
    Polyline polyline = Polyline(
      polylineId: id,
      color: primaryColor,
      points: _recordedPositions,
      width: 6,
    );
    
    setState(() {
      _polylines[id] = polyline;
    });
  }
  
  // Calculate calories burned based on MET values
  void _updateCaloriesBurned() {
    if (_currentSpeed <= 0) return;
    
    // MET values for different paces
    double met;
    if (_currentSpeed < 4) {
      // Walking slowly
      met = 2.0;
    } else if (_currentSpeed < 6.5) {
      // Walking briskly
      met = 3.5;
    } else if (_currentSpeed < 8) {
      // Light jogging
      met = 7.0;
    } else if (_currentSpeed < 11) {
      // Running
      met = 10.0;
    } else {
      // Sprinting
      met = 12.5;
    }
    
    // Calories burned per minute = MET * weight in kg * 3.5 / 200
    double caloriesPerMinute = (met * _userWeight * 3.5) / 200;
    // Calories per second
    double caloriesPerSecond = caloriesPerMinute / 60;
    
    _caloriesBurned = (_caloriesBurned + caloriesPerSecond).round();
  }

  // Format seconds into HH:MM:SS
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Show error message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  
  // Toggle map type
  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
  
  // Toggle following mode
  void _toggleFollowingMode() {
    setState(() {
      _isFollowingUser = !_isFollowingUser;
    });
    
    if (_isFollowingUser && _currentPosition != null) {
      _animateToCurrentPosition();
    }
  }
  
  // Animate to current position
  Future<void> _animateToCurrentPosition() async {
    if (_currentPosition == null) return;
    
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ),
    );
  }

  // Show summary dialog
  void _showSummaryDialog() {
    final duration = _formatTime(_timeElapsed);
    final distanceKm = (_distanceCovered / 1000).toStringAsFixed(2);
    final avgSpeedKmh = _averageSpeed.toStringAsFixed(1);
    final maxSpeedKmh = _maxSpeed.toStringAsFixed(1);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Session Summary',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow(context, 'Distance', '$distanceKm km', Icons.straighten),
              _buildSummaryRow(context, 'Duration', duration, Icons.timer),
              _buildSummaryRow(context, 'Avg Speed', '$avgSpeedKmh km/h', Icons.speed),
              _buildSummaryRow(context, 'Max Speed', '$maxSpeedKmh km/h', Icons.trending_up),
              _buildSummaryRow(context, 'Calories', '$_caloriesBurned kcal', Icons.local_fire_department),
              
              const SizedBox(height: 24),
              // Session date
              Text(
                'Session: ${DateFormat('dd MMM yyyy, HH:mm').format(_sessionStartTime ?? DateTime.now())}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              // Functionality to implement: save workout
              Navigator.of(context).pop();
              _showSnackBar('Workout saved successfully!');
            },
          ),
        ],
      ),
    );
  }
  
  // Build summary row for dialog
  Widget _buildSummaryRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Tracking'),
        actions: [
          IconButton(
            icon: Icon(_currentMapType == MapType.normal
                ? Icons.satellite_alt
                : Icons.map),
            onPressed: _toggleMapType,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          _isMapReady
              ? GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  mapType: _currentMapType,
                  markers: _markers,
                  polylines: Set<Polyline>.of(_polylines.values),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
                
          // Stats overlay at the top
          if (_isRecording)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (_isPaused)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: warningColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'PAUSED',
                          style: TextStyle(
                            color: warningColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Distance',
                          '${(_distanceCovered / 1000).toStringAsFixed(2)} km',
                        ),
                        _buildStatItem(
                          'Time',
                          _formatTime(_timeElapsed),
                        ),
                        _buildStatItem(
                          'Speed',
                          '${_currentSpeed.toStringAsFixed(1)} km/h',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
          // Control buttons at the bottom
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Center map button
                FloatingActionButton(
                  heroTag: 'centerMapBtn',
                  onPressed: _toggleFollowingMode,
                  backgroundColor: _isFollowingUser ? primaryColor : Colors.white,
                  foregroundColor: _isFollowingUser ? Colors.white : primaryColor,
                  child: Icon(_isFollowingUser ? Icons.gps_fixed : Icons.gps_not_fixed),
                ),
                
                // Start/pause/resume/stop buttons
                if (!_isRecording)
                  FloatingActionButton.extended(
                    heroTag: 'startBtn',
                    onPressed: _startRecording,
                    backgroundColor: successColor,
                    label: const Text('START'),
                    icon: const Icon(Icons.play_arrow),
                  )
                else
                  Row(
                    children: [
                      if (!_isPaused)
                        FloatingActionButton(
                          heroTag: 'pauseBtn',
                          onPressed: _pauseRecording,
                          backgroundColor: warningColor,
                          child: const Icon(Icons.pause),
                        )
                      else
                        FloatingActionButton(
                          heroTag: 'resumeBtn',
                          onPressed: _resumeRecording,
                          backgroundColor: successColor,
                          child: const Icon(Icons.play_arrow),
                        ),
                      const SizedBox(width: 16),
                      FloatingActionButton(
                        heroTag: 'stopBtn',
                        onPressed: _stopRecording,
                        backgroundColor: errorColor,
                        child: const Icon(Icons.stop),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build stat item for the overlay
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
}