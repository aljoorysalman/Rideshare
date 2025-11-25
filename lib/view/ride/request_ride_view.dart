import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/view/widgets/custom_textfield.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/view/ride/select_location_view.dart';
import 'package:rideshare/view/ride/waiting_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 90, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
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

            // GENDER LABEL
            const Text(
              "Choose a ride",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            // GENDER SELECTOR
            Row(
              children: [
                _genderButton("Females only"),
                const SizedBox(width: 12),
                _genderButton("Males only"),
              ],
            ),

            const SizedBox(height: 30),

            // CAR TYPE: ECONOMY
            _carTypeCard(
              title: "Rideshare Economy",
              time: "2 min",
              seats: "4",
              isSelected: selectedCar == "economy",
              onTap: () => setState(() => selectedCar = "economy"),
            ),

            // CAR TYPE: XL
            _carTypeCard(
              title: "Rideshare XL",
              time: "5 min",
              seats: "6",
              isSelected: selectedCar == "XL",
              onTap: () => setState(() => selectedCar = "XL"),
            ),

            const SizedBox(height: 30),

           Center(
              child: CustomButton(
                text: "Request",
                onPressed: () {
                Navigator.push(
                  context,
                 MaterialPageRoute(builder: (_) => const WaitingView()),
              );
        },
            isFullWidth: false,
            borderRadius: 30,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.black,
            textColor: Colors.white,
        ),
       )


          ],
        ),
      ),
    );
  }



  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _genderButton(String title) {
    bool isSelected = selectedGender == title;

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
        pickupLatLng = LatLng(
          result["latLng"].latitude,
          result["latLng"].longitude,
        );
      } else {
        dropoffController.text = result["address"];
        dropoffLatLng = LatLng(
          result["latLng"].latitude,
          result["latLng"].longitude,
        );
      }
    });
  }
}

