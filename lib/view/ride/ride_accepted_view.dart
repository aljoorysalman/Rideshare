import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/controller/driver_controller.dart';
import 'package:rideshare/model/driver_model.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/chat/chat_view.dart';
import'package:rideshare/view/widgets/cancel_button.dart';
import 'package:location/location.dart';
import 'package:rideshare/controller/emergency_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rideshare/model/ride_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AcceptedRideView extends StatefulWidget {
  final String driverID;      // The ID of the driver for this ride
  final LatLng pickupLatLng; // The pickup location coordinates

  const AcceptedRideView({
    super.key,
    required this.driverID,
    required this.pickupLatLng,
  });

  @override
  State<AcceptedRideView> createState() => _AcceptedRideViewState();
}

class _AcceptedRideViewState extends State<AcceptedRideView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        //  FIRST STREAM: Listen to the ride document in Firestore in real time
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("rides")
              .where("driverID", isEqualTo: widget.driverID)
              .limit(1)
              .snapshots(),
          builder: (context, rideSnap) {
            // If data is still loading then show spinner
            if (!rideSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            // If no ride exists → show message
            if (rideSnap.data!.docs.isEmpty) {
              return const Center(child: Text("No active ride found"));
            }

            // Convert the Firestore document into a RideModel object
            final rideDoc = rideSnap.data!.docs.first;
            final ride = RideModel.fromMap(
              rideDoc.id,
              rideDoc.data() as Map<String, dynamic>,
            );

            //  SECOND STREAM: Listen to driver’s live data (location, name, etc.)
            return StreamBuilder<DriverModel?>(
              stream: DriverController().streamDriver(widget.driverID),
              builder: (context, driverSnap) {
                if (!driverSnap.hasData) {
                  // Still loading → show spinner
                  return const Center(child: CircularProgressIndicator());
                }

                // Driver data is available
                final driver = driverSnap.data!;

                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(32),
                      ),

                      // MAIN CONTENT
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // DRIVER info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      driver.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 6),
                                    // Driver rating row
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.amber, size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          driver.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),
                                    // Car information
                                    Text(
                                      "${driver.carModel} • ${driver.carColor} • ${driver.plateNumber}",
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),
                              // Right side: call + message buttons
                              Column(
                                children: [
                                  _circleButton(
                                    icon: Icons.call,
                                    onTap: () {},
                                  ),
                                  const SizedBox(height: 12),
                                 _circleButton(
                                  icon: Icons.message_outlined,
                                  onTap: () {
                                   final studentID = FirebaseAuth.instance.currentUser!.uid;
                                   final driverID = widget.driverID;

                             // Sort IDs alphabetically so room ID is stable
                             final List<String> ids = [studentID, driverID]..sort();
                             final roomId = "${ids[0]}_${ids[1]}";

                               Navigator.push(
                                 context,
                                  MaterialPageRoute(
                                  builder: (_) => ChatView(roomId: roomId),
                                  ),
                                );
                                },
                             ),

                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // PICKUP PIN
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Text(
                                "Pickup PIN: ${ride.pickupPIN}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // SOS BUTTON
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () => _showEmergencyDialog(rideDoc.id),
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    "SOS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                     const SizedBox(height: 32),
                      Center(child:  CancelButton( id: rideDoc.id, isRide: true,),
                      ),
                   

                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  static Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFD9D9D9),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 22, color: Colors.black),
        ),
      ),
    );
  }

  // EMERGENCY DIALOG
  void _showEmergencyDialog(String rideID) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must choose Cancel or Send
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Emergency",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to send an emergency alert?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _sendEmergencyAlert(rideID); // FIXED
              },
              child: const Text("Send SOS"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendEmergencyAlert(String rideID) async {
    try {
      // Get student ID (from Firebase Auth)
      final studentID = FirebaseAuth.instance.currentUser!.uid;

      // Get current location
      LocationData loc = await Location().getLocation();
      LatLng currentLocation = LatLng(loc.latitude!, loc.longitude!);

      // Trigger emergency using  service
      await EmergencyController().triggerEmergency(
        studentID: studentID,
        driverID: widget.driverID, // passed from AcceptedRideView
        rideID: rideID,
        location: currentLocation,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("SOS triggered! Calling emergency contact..."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send SOS: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
