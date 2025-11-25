import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:rideshare/core/constants/app_colors.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/view/ride/ride_accepted_view.dart';

class WaitingView extends StatefulWidget {
  final String requestId;

  const WaitingView({super.key, required this.requestId});

  @override
  State<WaitingView> createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Animation for pulsing dots
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // Listen to ride request changes → navigate when matched
    FirebaseFirestore.instance
        .collection("ride_requests")
        .doc(widget.requestId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final status = data["status"];

      /// When controller finishes matching a driver:
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

      /// If request rejected (rare case)
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

  // -----------------------------------------------------------
  // PULSING DOT
  // -----------------------------------------------------------
  Widget _buildPulsingDot(int index) {
    final double angle = (index * 45) * pi / 180;
    const double radius = 30;

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

  // -----------------------------------------------------------
  // UI
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulsing dots animation
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(8, (i) => _buildPulsingDot(i)),
              ),
            ),

            const Gap(40),

            const Text(
              "Looking for a driver nearby...",
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
          ],
        ),
      ),
    );
  }
}
