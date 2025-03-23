import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
// ignore: unused_import
import 'package:permission_handler/permission_handler.dart';
// ignore: unused_import
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GPSMapScreen extends StatefulWidget {
  const GPSMapScreen({super.key});

  @override
  _GPSMapScreenState createState() => _GPSMapScreenState();
}

class _GPSMapScreenState extends State<GPSMapScreen> {
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
  
  // Timer for regular position updates
  Timer? _locationTimer;
  
  // Distance covered (in meters)
  double _distanceCovered = 0;
  
  // Time elapsed (in seconds)
  int _timeElapsed = 0;
  Timer? _timeTimer;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _timeTimer?.cancel();
    super.dispose();
  }

  // Check and request location permissions
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled. Please enable them to use this feature.');
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorDialog('Location permissions are denied. Please enable them to use this feature.');
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog(
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
          ),
        );
      });
      
      // Move camera to current position
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
    } catch (e) {
      print('Error getting location: $e');
      _showErrorDialog('Failed to get current location: $e');
    }
  }

  // Start recording route
  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordedPositions.clear();
      _distanceCovered = 0;
      _timeElapsed = 0;
      
      if (_currentPosition != null) {
        _recordedPositions.add(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        );
      }
    });
    
    // Start timer for position updates
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateLocation();
    });
    
    // Start timer for elapsed time
    _timeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });
    });
  }

  // Stop recording route
  void _stopRecording() {
    _locationTimer?.cancel();
    _timeTimer?.cancel();
    
    setState(() {
      _isRecording = false;
    });
    
    // Show summary dialog
    if (_recordedPositions.length > 1) {
      _showSummaryDialog();
    }
  }

  // Update location and add to recorded positions
  Future<void> _updateLocation() async {
    if (!_isRecording) return;
    
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
          _distanceCovered += distance;
        }
        
        _currentPosition = position;
        LatLng newPosition = LatLng(position.latitude, position.longitude);
        _recordedPositions.add(newPosition);
        
        // Update current location marker
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: newPosition,
            infoWindow: const InfoWindow(title: 'My Location'),
          ),
        );
        
        // Update polyline
        _updatePolylines();
      });
      
      // Move camera to current position
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
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
      color: Colors.blue,
      points: _recordedPositions,
      width: 5,
    );
    
    setState(() {
      _polylines[id] = polyline;
    });
  }

  // Format seconds into HH:MM:SS
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show summary dialog after recording
  void _showSummaryDialog() {
    // Calculate average speed in km/h
    double avgSpeedKmh = 0;
    if (_timeElapsed > 0) {
      avgSpeedKmh = (_distanceCovered / 1000) / (_timeElapsed / 3600);
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Distance: ${(_distanceCovered / 1000).toStringAsFixed(2)} km'),
            const SizedBox(height: 8),
            Text('Duration: ${_formatTime(_timeElapsed)}'),
            const SizedBox(height: 8),
            Text('Average Speed: ${avgSpeedKmh.toStringAsFixed(2)} km/h'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Option to save in a future implementation
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            zoomControlsEnabled: false,
            markers: _markers,
            polylines: Set<Polyline>.of(_polylines.values),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          
          // Stats Panel
          if (_isRecording)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.white.withOpacity(0.8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Distance', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${(_distanceCovered / 1000).toStringAsFixed(2)} km'),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(_formatTime(_timeElapsed)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Speed', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            _timeElapsed > 0
                                ? '${((_distanceCovered / 1000) / (_timeElapsed / 3600)).toStringAsFixed(2)} km/h'
                                : '0.00 km/h',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isRecording ? _stopRecording : _startRecording,
        icon: Icon(_isRecording ? Icons.stop : Icons.play_arrow),
        label: Text(_isRecording ? 'Stop' : 'Start'),
        backgroundColor: _isRecording ? Colors.red : Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}