// These are all the same imports you had — no changes needed
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:rideshare/view/auth/signup_view.dart';

// Splash screen (first page that opens)
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();

    // Controller handles the zoom & color animation after delay
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 3s smooth zoom + fade
    );

    // Logo zooms from 1x → 12x smoothly
    _scaleAnim = Tween<double>(begin: 1.0, end: 12.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    // Background fades from white → black
    _colorAnim = ColorTween(begin: Colors.white, end: Colors.black).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    // Step 1️⃣: Wait 2 seconds so user can read the logo/text first
    Timer(const Duration(seconds: 2), () {
      // Step 2️⃣: Start the zoom + fade animation
      _controller.forward();
    });

    // Step 3️⃣: When animation completes, open Signup page
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SignupView(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Fade in signup screen smoothly
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _colorAnim.value, // background animates to black
         body: Center(
          child: Transform.scale(
           scale: _scaleAnim.value,
             child: SvgPicture.asset(
             "img/RideShare.svg",

    width: MediaQuery.of(context).size.width * 0.7,  // 70% of screen width
    fit: BoxFit.contain, // Keeps proportions
     // keeps proportions, avoids stretching
    ),
  ),
),

        );
      },
    );
  }
}