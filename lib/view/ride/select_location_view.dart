import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/widgets/custom_button.dart'; // عدلي المسار لو مختلف

class SelectLocationView extends StatefulWidget {
  final bool isPickup;

  const SelectLocationView({super.key, required this.isPickup});

  @override
  State<SelectLocationView> createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView> {
  GoogleMapController? _mapController;
  LatLng? selectedLatLng;
  String selectedAddress = "";

  static const LatLng riyadhCenter = LatLng(24.7136, 46.6753);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.isPickup ? "Select Pickup" : "Select Drop-off",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        // شلنا const عشان ما يعترض على AppColors
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: riyadhCenter,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: _handleMapTap,
            markers: selectedLatLng == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: selectedLatLng!,
                    ),
                  },
          ),

          // زر التأكيد
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

  Future<void> _handleMapTap(LatLng latLng) async {
    setState(() {
      selectedLatLng = latLng;
    });

    // تحويل الإحداثيات لعنوان
    final placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    final p = placemarks.first;

    setState(() {
      selectedAddress =
          "${p.street ?? ''}, ${p.locality ?? ''}, ${p.country ?? ''}";
    });
  }

  void _confirmSelection() {
    Navigator.pop(context, {
      "latLng": selectedLatLng,
      "address": selectedAddress,
    });
  }
}
