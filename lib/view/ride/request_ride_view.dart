import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/ride/select_location_view.dart';
import 'package:rideshare/view/ride/waiting_view.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/controller/RideRequestController';
import 'package:rideshare/controller/ride_matching_controller.dart';
import 'package:rideshare/model/driver_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestRideView extends StatefulWidget {
  const RequestRideView({super.key});

  @override
  State<RequestRideView> createState() => _RequestRideViewState();
}

class _RequestRideViewState extends State<RequestRideView> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();

  LatLng? pickupLatLng;
  LatLng? dropoffLatLng;

  String selectedGender = "Females only";
  String selectedCar = "economy";

  final RideRequestController rideController = RideRequestController();
  final RideMatchingController matchingController = RideMatchingController();

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Request a Ride",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: CustomButton(
                text: "Request",
                onPressed: _submitRide,
                isFullWidth: false,
                borderRadius: 30,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                color: Colors.black,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------- S3 + S4 ----------------------

  Future<void> _submitRide() async {
    final error = rideController.validateInputs(
      pickupAddress: pickupController.text,
      dropoffAddress: dropoffController.text,
      pickupLat: pickupLatLng?.latitude,
      pickupLng: pickupLatLng?.longitude,
      dropoffLat: dropoffLatLng?.latitude,
      dropoffLng: dropoffLatLng?.longitude,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    final request = rideController.createRideRequest(
      pickupAddress: pickupController.text,
      dropoffAddress: dropoffController.text,
      pickupLat: pickupLatLng!.latitude,
      pickupLng: pickupLatLng!.longitude,
      dropoffLat: dropoffLatLng!.latitude,
      dropoffLng: dropoffLatLng!.longitude,
      riderId: "userID_here",
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await rideController.saveToFirebase(request);

      // ⭐ STEP 2: إنشاء غرفة شات لكل رحلة
      String roomId = request.requestId;

      await FirebaseFirestore.instance
          .collection("messages")
          .doc(roomId)
          .set({
        "user1": request.riderId,
        "user2": "",
        "lastMessage": "",
        "timestamp": DateTime.now(),
      });

      // ⭐ STEP 3: الذهاب لواجهة الانتظار وتمرير roomId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WaitingView(roomId: roomId),
        ),
      );

      final List<DriverModel> matches =
          await matchingController.findMatchesForRequest(request);

      Navigator.pop(context);

      if (matches.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No available drivers for this ride")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Found ${matches.length} matching drivers")),
        );
      }

      pickupController.clear();
      dropoffController.clear();
      pickupLatLng = null;
      dropoffLatLng = null;
      setState(() {});

    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting request: $e")),
      );
    }
  }

  // ---------------------- Location Selector ----------------------

  Future<void> _openLocationSelector(bool isPickup) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectLocationView(isPickup: isPickup),
      ),
    );

    if (result == null) return;

    setState(() {
      if (isPickup) {
        pickupController.text = result["address"];
        pickupLatLng = result["latLng"];
      } else {
        dropoffController.text = result["address"];
        dropoffLatLng = result["latLng"];
     }
});
}
}