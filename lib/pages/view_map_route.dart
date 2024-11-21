import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class ViewMapRoute extends StatefulWidget {
  const ViewMapRoute({super.key});

  @override
  State<ViewMapRoute> createState() => _ViewMapRouteState();
}

class _ViewMapRouteState extends State<ViewMapRoute> {
  final Completer<GoogleMapController> _mapController = Completer();

  // Coordinates for pickup and delivery locations in Rwanda
  final LatLng _pickupLocation = const LatLng(-1.9706, 30.1044); // Kigali, Rwanda
  final LatLng _deliveryLocation = const LatLng(-2.0000, 30.1200); // Example delivery location near Kigali

  final Location _location = Location(); // Initialize Location for live tracking

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _checkLocationPermission(); // Ensure permissions are handled
    _setMarkers();
    _setPolylines();
  }

  /// Check and request location permissions
  Future<void> _checkLocationPermission() async {
    final bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      await _location.requestService();
    }

    final PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      await _location.requestPermission();
    }
  }

  /// Add markers for pickup and delivery locations
  void _setMarkers() {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLocation,
          infoWindow: const InfoWindow(title: 'Pickup Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        Marker(
          markerId: const MarkerId('delivery'),
          position: _deliveryLocation,
          infoWindow: const InfoWindow(title: 'Delivery Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      };
    });
  }

  /// Draw a polyline (route) between pickup and delivery locations
  void _setPolylines() {
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: [
            _pickupLocation,
            LatLng(-1.9800, 30.1100), // Example intermediate location
            _deliveryLocation,
          ],
          color: Colors.orange,
          width: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Map - Rwanda"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Google Map Widget
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLocation, // Center the map on Kigali, Rwanda
              zoom: 12.0, // Zoom level
            ),
            markers: _markers, // Add markers
            polylines: _polylines, // Add polylines for the route
            myLocationEnabled: true, // Enable live location
            myLocationButtonEnabled: true, // Show location button
            zoomControlsEnabled: true, // Allow zoom controls
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
          ),
          // Accept and Reject Buttons
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Reject Action
                      print("Delivery rejected");
                    },
                    child: const Text("Reject"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Accept Action
                      print("Delivery accepted");
                    },
                    child: const Text("Accept"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
