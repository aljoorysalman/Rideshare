import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rideshare/view/widgets/custom_button.dart';
import 'package:rideshare/core/constants/app_colors.dart';

class WaitingView extends StatefulWidget {
  const WaitingView({super.key});

  @override
  State<WaitingView> createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
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
                  style: TextStyle(fontSize: 15, color:AppColors.greyBackground,),
                ),
              ],
            ),

            const SizedBox(height: 40),

            CustomButton(
              text: "Cancel ride",
              onPressed: () => Navigator.pop(context),
              isFullWidth: false,
              borderRadius: 30,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              color: Colors.black,
              textColor: Colors.white,
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

