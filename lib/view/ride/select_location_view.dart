import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';


class SelectLocationView extends StatefulWidget {
  final bool isPickup; // true = pickup, false = dropoff screen

  const SelectLocationView({super.key, required this.isPickup});

  @override
  State<SelectLocationView> createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView> {
  LatLng? selectedLatLng;  // User-selected coordinates
  String selectedAddress = "Selected location"; // Placeholder address

  // Center of Riyadh
  static const LatLng riyadhCenter = LatLng(24.7136, 46.6753);

  GoogleMapController? _googleMapController;
  final Location _location = Location(); //// For getting GPS location

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  
  // Move camera to user's current location using Location() package
  
  Future<void> _moveToUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

     // Check if location service is ON
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    // Check permission to access location
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get user's current location
    LocationData userLocation = await _location.getLocation();

    if (userLocation.latitude == null || userLocation.longitude == null) {
      return;
    }

    final lat = userLocation.latitude!;
    final lng = userLocation.longitude!;

 //  simple check: is the location in Saudi Arabia?
    final isInSaudi =
        lat >= 16.0 && lat <= 32.0 && lng >= 34.0 && lng <= 56.0;

// If emulator gives fake/invalid location, show messag
    if (!isInSaudi) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Your current location seems incorrect. Showing Riyadh instead.",
            ),
          ),
        );
      }
      return;
    }
    // Move Google Map camera to user’s location
    if (_googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 16,
          ),
        ),
      );
    }
  }

   // When user taps the map → store the selected location
  Future<void> _handleMapTap(LatLng latLng) async {
    setState(() {
      selectedLatLng = latLng;
      selectedAddress = "Selected location";
    });
  }

  
  // Return selected location back to previous screen
  
  void _confirmSelection() {
    Navigator.pop(context, {
      "latLng": selectedLatLng,
      "address": selectedAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
       // App bar title switches based on isPickup flag
      appBar: AppBar(
        title: Text(
          widget.isPickup ? "Select Pickup" : "Select Drop-off",
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        // Button to center map to user's GPS
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: AppColors.primary),
            onPressed: _moveToUserLocation, // ✅ Only moves when user taps
          ),
        ],
      ),

      body: Stack(
        children: [
          // GOOGLE MAP UI
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: riyadhCenter,
              zoom: 14,
            ),
             zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
           tiltGesturesEnabled: true,
           
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
  },



            onMapCreated: (controller) {
              _googleMapController = controller;
            },
            onTap: (LatLng point) => _handleMapTap(point), // Save tap location
  
              // Show marker only when user picks a point
            markers: selectedLatLng == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: selectedLatLng!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  },
          ),

          // CONFIRM BUTTON 
          Positioned(
            left: 16,
            right: 16,
            bottom: 22,
            child: CustomButton(
              text: "Confirm location",
              onPressed:
                  selectedLatLng == null ? () {} : _confirmSelection,
              color: selectedLatLng == null
                  ? AppColors.lightGreyBackground
                  : AppColors.primary,
              textColor: selectedLatLng == null
                  ? AppColors.textSecondary
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
