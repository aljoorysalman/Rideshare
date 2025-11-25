import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/controller/driver_controller.dart';
import 'package:rideshare/model/driver_model.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/chat/chat_screen.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/view/ride/home_view.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare/controller/emergency_controller.dart';


class AcceptedRideView extends StatefulWidget {
  final String driverID;
  final LatLng pickupLatLng;

  const AcceptedRideView({
    super.key,
    required this.driverID,
    required this.pickupLatLng,
  });

  @override
  State<AcceptedRideView> createState() => _AcceptedRideViewState();
}

class _AcceptedRideViewState extends State<AcceptedRideView> {
  late String pickupPin;

  @override
  void initState() {
    super.initState();
    pickupPin = _generatePickupPin();
  }

  String _generatePickupPin() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return (random % 9000 + 1000).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<DriverModel?>(
          stream: DriverController().streamDriver(widget.driverID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("Driver data not available"),
              );
            }

            final driver = snapshot.data!;

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

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // DRIVER HEADER
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LEFT SIDE
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

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
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

                                Text(
                                  "${driver.carModel} • ${driver.carColor} • ${driver.plateNumber}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // CALL + MESSAGE BTONS
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ChatScreen(),
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
                            "PickupPIN: $pickupPin",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),


             
           // EMERGENCY SOS BUTTON

       Align(
          alignment: Alignment.centerRight,       
           child: InkWell(
            onTap: () {
              _showEmergencyDialog();
             },
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







                      // CANCEL BUTTON
                     Center(
                       child: CustomButton(
                         text: "Cancel ride",
                           onPressed: () {
                            Navigator.pushReplacement(
                             context,
                            MaterialPageRoute(builder: (_) => const HomeView()),
                           );
                         },
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
              ),
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
          child: Icon(
            icon,
            size: 22,
            color: Colors.black,
          ),
        ),
      ),
    );

  }

  void _showEmergencyDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Emergency"),
      content: Text(
        "Are you sure you want to send an emergency alert?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
            _sendEmergencyAlert();
          },
          child: Text("Send SOS"),
        ),
      ],
    ),
  );
}
Future<void> _sendEmergencyAlert() async {
  try {
    // Get student ID (from Firebase Auth)
   // final studentID = FirebaseAuth.instance.currentUser!.uid;
   final studentID = "STU001";


    // Get current location
    LocationData loc = await Location().getLocation();
    LatLng currentLocation = LatLng(loc.latitude!, loc.longitude!);

    // Trigger emergency using your service
    await EmergencyController().triggerEmergency(
      studentID: studentID,
      driverID: widget.driverID, // passed from AcceptedRideView
      rideID: "RIDE_123",        // replace with actual ride ID
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
