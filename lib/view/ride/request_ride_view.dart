import 'package:flutter/material.dart';
import 'package:rideshare/view/widgets/custom_textfield.dart';
import 'package:rideshare/view/ride/select_location_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request a Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // PICKUP FIELD
            CustomTextField(
              hint: "Pickup Location",
              controller: pickupController,
              readOnly: true,
              onTap: () => _openLocationSelector(true),
            ),

            const SizedBox(height: 16),

            // DROPOFF FIELD
            CustomTextField(
              hint: "Drop-off Location",
              controller: dropoffController,
              readOnly: true,
              onTap: () => _openLocationSelector(false),
            ),
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
        pickupLatLng = result["latLng"];
      } else {
        dropoffController.text = result["address"];
        dropoffLatLng = result["latLng"];
      }
    });
  }
}

