import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/view/widgets/custom_textfield.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/view/ride/select_location_view.dart';
import 'package:rideshare/controller/ride/reserve_ride_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare/view/ride/home_view.dart';

class ReserveRideView extends StatefulWidget {
  const ReserveRideView({super.key});

  @override
  State<ReserveRideView> createState() => _ReserveRideViewState();
}

class _ReserveRideViewState extends State<ReserveRideView> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();
  final TextEditingController scheduleController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();

  LatLng? pickupLatLng;
  LatLng? dropoffLatLng;
  DateTime? selectedSchedule;

  final ReserveRideController reserveController = ReserveRideController();

  @override
  void dispose() {
    pickupController.dispose();
    dropoffController.dispose();
    scheduleController.dispose();
    seatsController.dispose();
    super.dispose();
  }

  // اختيار الموقع
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

  // اختيار وقت الحجز
  Future<void> _pickSchedule() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    selectedSchedule = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    scheduleController.text =
        "${date.year}-${date.month}-${date.day}   ${time.format(context)}";
  }

  // إرسال الحجز
  Future<void> _submitReservation() async {
    final error = reserveController.validateReserveInputs(
      pickupAddress: pickupController.text,
      dropoffAddress: dropoffController.text,
      pickupLat: pickupLatLng?.latitude,
      pickupLng: pickupLatLng?.longitude,
      dropoffLat: dropoffLatLng?.latitude,
      dropoffLng: dropoffLatLng?.longitude,
      scheduledTime: selectedSchedule,
      seats: int.tryParse(seatsController.text) ?? 0,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    final riderId = FirebaseAuth.instance.currentUser!.uid;

    final reservation = reserveController.createReservation(
      pickupAddress: pickupController.text,
      dropoffAddress: dropoffController.text,
      pickupLat: pickupLatLng!.latitude,
      pickupLng: pickupLatLng!.longitude,
      dropoffLat: dropoffLatLng!.latitude,
      dropoffLng: dropoffLatLng!.longitude,
      scheduledTime: selectedSchedule!,
      riderId: riderId,
      direction: "HomeToCampus",
      seats: int.parse(seatsController.text),
    );

    await reserveController.saveReservation(reservation);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reservation saved successfully")),
    );
  }

  // نقطة الألوان
  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.black),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    },
  ),

),


      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Plan your ride",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 25),

            // PICKUP
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

            const SizedBox(height: 18),

            // DROPOFF
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

            const SizedBox(height: 22),

            // SCHEDULE FIELD
            CustomTextField(
              hint: "Schedule",
              controller: scheduleController,
              readOnly: true,
              onTap: _pickSchedule,
            ),

            const SizedBox(height: 18),

            // SEATS FIELD
            CustomTextField(
              hint: "Seats",
              controller: seatsController,
            ),

            const SizedBox(height: 40),

            // RESERVE BUTTON
            Center(
              child: CustomButton(
                text: "Reserve",
                onPressed: _submitReservation,
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
}
