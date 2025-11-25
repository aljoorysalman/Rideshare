import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/chat/chat_view.dart';
import 'package:rideshare/view/ride/ride_accepted_view.dart';

class WaitingView extends StatefulWidget {
  final String roomId;
  const WaitingView({super.key, required this.roomId});

  @override
  State<WaitingView> createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView>
    with SingleTickerProviderStateMixin {
  GoogleMapController? mapController;

  Marker driverMarker = const Marker(
    markerId: MarkerId("driver"),
    position: LatLng(0, 0),
  );

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // --------------------------- 👇 NEW IMPORTANT CODE 👇 ---------------------------
    FirebaseFirestore.instance
        .collection("ride_requests")
        .doc(widget.roomId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final status = snapshot.data()?["status"];
      final driverName = snapshot.data()?["driver_name"] ?? "Driver";

      if (status == "accepted") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RideAcceptedView(
              roomId: widget.roomId,
              driverName: driverName,
            ),
          ),
        );
      }

      if (status == "rejected") {
        Navigator.pop(context);
      }
    });
    // -------------------------------------------------------------------------------

    FirebaseFirestore.instance
        .collection("drivers_live_location")
        .doc("Uxfc5zJgFui6ndkj6jgdP")
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final double lat = data["lat"];
      final double lng = data["lng"];

      setState(() {
        driverMarker = Marker(
          markerId: const MarkerId("driver"),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        );
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.7146, 46.6764),
                zoom: 15,
              ),
              markers: {driverMarker},
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(widget.roomId)
                  .collection("chat")
                  .orderBy("timestamp")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final msgs = snapshot.data!.docs;

                if (msgs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages yet...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final msg = msgs[index];
                    final isMe = msg["senderId"] == "user1";

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.black : Colors.grey[300],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          msg["message"],
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const Gap(20),

          const Text(
            "Looking for a driver nearby",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.greyBackground,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 35),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.navigation, color: AppColors.greyBackground, size: 22),
              SizedBox(width: 8),
              Text(
                "Searching within 7 km",
                style: TextStyle(fontSize: 15, color: AppColors.greyBackground),
              ),
            ],
          ),

          const SizedBox(height: 40),

          CustomButton(
            text: "Cancel ride",
            onPressed: () => Navigator.pop(context),
            isFullWidth: false,
            borderRadius: 30,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.black,
            textColor: Colors.white,
          ),

          const SizedBox(height: 20),

          CustomButton(
            text: "Chat with driver",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatView(roomId: widget.roomId),
                ),
              );
            },
            isFullWidth: false,
            borderRadius: 30,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: Colors.black,
            textColor: Colors.white,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPulsingDot(int index) {
    final double angle = (index * 45) * pi / 180;
    final double radius = 30;
    double fade = (sin(_controller.value * 2 * pi + index * 0.7) + 1) / 2;

    return Transform.translate(
      offset: Offset(radius * cos(angle), radius * sin(angle)),
      child: Opacity(
        opacity: fade * 0.9 + 0.1,
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
     ),
);
}
}