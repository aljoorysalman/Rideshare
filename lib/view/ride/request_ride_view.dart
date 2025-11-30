import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/view/widgets/custom_textfield.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/view/ride/select_location_view.dart';
import 'package:rideshare/view/ride/waiting_view.dart';
import 'package:rideshare/controller/ride/Ride_Request_Controller.dart';
import 'package:rideshare/controller/ride/ride_matching_controller.dart';
import 'package:rideshare/model/ride/ride_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

            //  REQUEST BUTTON 
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
Future<void> _submitRide() async {
  // Validate text + coordinates
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

  // FINAL SAFETY: prevent null crashes
  if (pickupLatLng == null || dropoffLatLng == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select both locations.")),
    );
    return;
  }

  try {
    // 1. Create request object
    final RideRequestModel request = requestController.createRequest(
      pickupAddress: pickupController.text,
      dropoffAddress: dropoffController.text,
      pickupLat: pickupLatLng!.latitude,
      pickupLng: pickupLatLng!.longitude,
      dropoffLat: dropoffLatLng!.latitude,
      dropoffLng: dropoffLatLng!.longitude,
      riderId: FirebaseAuth.instance.currentUser!.uid,
      requestID: requestController.generateRequestID(),
    );

    // 2. Save request
    await requestController.saveToFirebase(request);

    // 3. Create chat room
    FirebaseFirestore.instance
        .collection("messages")
        .doc(request.requestID)
        .set({
      "user1": request.riderId,
      "user2": "",
      "lastMessage": "",
      "timestamp": DateTime.now(),
    });

    // 4. Navigate to waiting screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WaitingView(requestId: request.requestID),
      ),
    );

    // 5. Start matching
    matchingController.handleFullRideFlow(request);

    // 6. Reset fields
    pickupController.clear();
    dropoffController.clear();
    pickupLatLng = null;
    dropoffLatLng = null;
    setState(() {});
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Something went wrong. Please try again.")),
    );
    print("Submit ride failed: $e");
  }
}


  // LOCATION SELECTOR
  Future<void> _openLocationSelector(bool isPickup) async {
    final result = await Navigator.push(
      context,
      
      MaterialPageRoute(
        builder: (_) => SelectLocationView(isPickup: isPickup),
      ),
      
    );

    if (result == null) return;

    setState(() {
      final String address = (result["address"] ?? "") as String;
      final LatLng? latLng = result["latLng"] as LatLng?;

      if (isPickup) {
        pickupController.text = address;
        pickupLatLng = latLng;
      } else {
        dropoffController.text = address;
        dropoffLatLng = latLng;
      }
    });
  }

  // UI ELEMENTS

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

}
