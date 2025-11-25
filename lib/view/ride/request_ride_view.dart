import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/view/widgets/custom_textfield.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/view/ride/select_location_view.dart';
import 'package:rideshare/view/ride/waiting_view.dart';

import 'package:rideshare/controller/ride_request_controller.dart';
import 'package:rideshare/controller/ride_matching_controller.dart';
import 'package:rideshare/model/ride_request_model.dart';

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

  // controllers
  final RideRequestController requestController = RideRequestController();
  final RideMatchingController matchingController = RideMatchingController();

  String selectedGender = "Females only";
  String selectedCar = "economy";

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
        padding: const EdgeInsets.fromLTRB(20, 90, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Where to?",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            // PICKUP FIELD
            Row(
              children: [
                _dot(Colors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    hint: "Pickup Location",
                    controller: pickupController,
                    readOnly: true,
                    onTap: () => _openLocationSelector(true),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // DROPOFF FIELD
            Row(
              children: [
                _dot(Colors.red),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    hint: "Drop-off Location",
                    controller: dropoffController,
                    readOnly: true,
                    onTap: () => _openLocationSelector(false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Choose a ride",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _genderButton("Females only"),
                const SizedBox(width: 12),
                _genderButton("Males only"),
              ],
            ),

            const SizedBox(height: 30),

            _carTypeCard(
              title: "Rideshare Economy",
              time: "2 min",
              seats: "4",
              isSelected: selectedCar == "economy",
              onTap: () => setState(() => selectedCar = "economy"),
            ),

            _carTypeCard(
              title: "Rideshare XL",
              time: "5 min",
              seats: "6",
              isSelected: selectedCar == "XL",
              onTap: () => setState(() => selectedCar = "XL"),
            ),

            const SizedBox(height: 30),

            // 🔥 REQUEST BUTTON WITH REAL LOGIC
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

  // ---------------------------------------------------------
  // SUBMIT RIDE → create request → save → go to WaitingView
  // ---------------------------------------------------------
  Future<void> _submitRide() async {
    final error = requestController.validateInputs(
      pickupAddress: pickupController.text,
      dropoffAddress: dropoffController.text,
      pickupLat: pickupLatLng?.latitude,
      pickupLng: pickupLatLng?.longitude,
      dropoffLat: dropoffLatLng?.latitude,
      dropoffLng: dropoffLatLng?.longitude,
    );

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    // 1. Create request object
    final RideRequestModel request = requestController.createRequest(
      pickupAddress: pickupController.text,
      dropoffAddress: dropoffController.text,
      pickupLat: pickupLatLng!.latitude,
      pickupLng: pickupLatLng!.longitude,
      dropoffLat: dropoffLatLng!.latitude,
      dropoffLng: dropoffLatLng!.longitude,
      riderId: "userID_here", // replace later
      requestID: requestController.generateRequestID(),
    );

    // 2. Save request to Firestore
    await requestController.saveToFirebase(request);

    // 3. Create chat room (optional)
    FirebaseFirestore.instance
        .collection("messages")
        .doc(request.requestID)
        .set({
      "user1": request.riderId,
      "user2": "",
      "lastMessage": "",
      "timestamp": DateTime.now(),
    });

    // 4. Navigate to WAITING SCREEN immediately
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WaitingView(requestId: request.requestID),
      ),
    );

    // 5. Start matching (no blocking UI)
    try {
      await matchingController.handleFullRideFlow(request);
    } catch (e) {
      print("Matching failed: $e");
    }

    // 6. Reset fields
    pickupController.clear();
    dropoffController.clear();
    pickupLatLng = null;
    dropoffLatLng = null;
    setState(() {});
  }

  // ---------------------------------------------------------
  // LOCATION SELECTOR
  // ---------------------------------------------------------
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

  // ---------------------------------------------------------
  // UI ELEMENTS
  // ---------------------------------------------------------

  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _genderButton(String title) {
    final bool isSelected = selectedGender == title;

    return GestureDetector(
      onTap: () => setState(() => selectedGender = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _carTypeCard({
    required String title,
    required String time,
    required String seats,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.navigation, size: 40, color: Colors.black54),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 16),
                    Text(" $time   "),
                    const Icon(Icons.person, size: 16),
                    Text(" $seats"),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
