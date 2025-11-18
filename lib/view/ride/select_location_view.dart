import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/core/constants/app_colors.dart';

class SelectLocationView extends StatefulWidget {
  final bool isPickup;

  const SelectLocationView({super.key, required this.isPickup});

  @override
  State<SelectLocationView> createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView> {
  LatLng? selectedLatLng;
  String selectedAddress = "";

  static const LatLng riyadhCenter = LatLng(24.7136, 46.6753);

  GoogleMapController? _googleMapController;

  @override
  void dispose() {
    _googleMapController?.dispose(); // ⭐ FIX: Destroys the map fully
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.isPickup ? "Select Pickup" : "Select Drop-off",
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Stack(
        children: [
          /// ⭐ GOOGLE MAP
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: riyadhCenter,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _googleMapController = controller;
            },
            onTap: (LatLng point) {
              _handleMapTap(point);
            },

            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,

            markers: selectedLatLng == null
                ? <Marker>{}
                : {
                    Marker(
                      markerId: const MarkerId("selectedLocation"),
                      position: selectedLatLng!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    )
                  },
          ),

          /// ⭐ Confirm Button
          Positioned(
            left: 16,
            right: 16,
            bottom: 22,
            child: CustomButton(
              text: "Confirm location",
              onPressed: selectedLatLng == null ? () {} : _confirmSelection,
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

  /// ⭐ Save map tap & reverse-geocode
  Future<void> _handleMapTap(LatLng latLng) async {
    setState(() {
      selectedLatLng = latLng;
    });

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      Placemark p = placemarks.first;

      setState(() {
        selectedAddress =
            "${p.street ?? ''}, ${p.locality ?? ''}, ${p.country ?? ''}";
      });
    } catch (e) {
      selectedAddress = "Selected location";
    }
  }

  /// ⭐ Return selected point back
  void _confirmSelection() {
    Navigator.pop(context, {
      "latLng": selectedLatLng,
      "address": selectedAddress,
    });
  }
}
