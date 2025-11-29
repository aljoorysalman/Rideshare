import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/view/ride/ride_accepted_view.dart';
import'package:rideshare/view/widgets/cancel_button.dart';

class WaitingView extends StatefulWidget {
  final String requestId; // ID of the ride request in Firestore
  const WaitingView({
    super.key,
    required this.requestId,
  });

  @override
  State<WaitingView> createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    
    // Animation controller for pulsing dots
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();


    // Listen to ride request changes  navigate when matched
    // Listen to Firestore request updates (real-time)
    FirebaseFirestore.instance
        .collection("ride_requests")
        .doc(widget.requestId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final status = data["status"];

      // If a driver matched navigate to AcceptedRide screen
      if (status == "matched") {
        final driverId = data["driverId"];
        final pickupLat = data["pickupLat"];
        final pickupLng = data["pickupLng"];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AcceptedRideView(
              driverID: driverId,
              pickupLatLng: LatLng(pickupLat, pickupLng),
            ),
          ),
        );
      }

      // If request is rejected (driver unavailable)  go back to home
      if (status == "rejected") {
        Navigator.pop(context);
      }
    });
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
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // pulsing circular dots

          const SizedBox(height: 20),

          SizedBox(
            width: 90,
            height: 90,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(8, _buildPulsingDot),
                  ),
                );
              },
            ),
          ),

          Gap(20),

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
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.greyBackground,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          const SizedBox(height: 32),

          // Cancel request button (cancels only ride_request)
          Center(
            child: CancelButton(
              id: widget.requestId,
              isRide: false,
            ),
          ),
        ],
      ),
    ),
  );
}

  // Pulsing dot around the circle
  Widget _buildPulsingDot(int index) {
    final double angle = (index * 45) * pi / 180;
    final double radius = 30;

    // phase shift for smooth wave motion
    double fade = (sin(_controller.value * 2 * pi + index * 0.7) + 1) / 2;

    return Transform.translate(
      offset: Offset(radius * cos(angle), radius * sin(angle)),
      child: Opacity(
        opacity: fade * 0.9 + 0.1, // soft fade
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
