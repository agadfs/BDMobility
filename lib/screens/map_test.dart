import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  Location _location = Location();
  LatLng? _currentLocation;

  double _mapHeight = 500; // Initial height of the map
  bool _isExpanded = false; // To toggle map height

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if location services are enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if location permission is granted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get the current location
    LocationData locationData = await _location.getLocation();

    setState(() {
      _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });

    // Move the map to the current location
    _mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
  }

  // Function to create markers on the map
  Set<Marker> _createMarkers() {
    if (_currentLocation != null) {
      return {
        Marker(
          markerId: MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: InfoWindow(title: 'You are here'),
        ),
      };
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps with Draggable Bottom Sheet'),
        actions: [
          IconButton(
            icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
                _mapHeight = _isExpanded ? 600 : 300;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Animated container for the Google Map
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _mapHeight,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? LatLng(37.42796133580664, -122.085749655962), // Set any default location
                zoom: 14.4746,
              ),
              markers: _createMarkers(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
          // DraggableScrollableSheet for the bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Draggable Bottom Sheet',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'This bottom sheet is displayed by default and is draggable. It resizes the map above when dragged. You can add more content here as needed.',
                        ),
                        // Add more widgets as needed for your bottom sheet content
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
