// 📦 Imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rideshare/view/ride/home_view.dart';
import 'package:rideshare/core/constants/app_colors.dart';

// 🚀 Splash screen (simple fade into home)
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    // ⏳ Wait for 3 seconds, then navigate with fade
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeView(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            // 🎞 Smooth fade transition
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800), // fade speed
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, //  white background
      body: Center(
        child: SvgPicture.asset(
          "img/RideShare.svg", // your logo
          width: MediaQuery.of(context).size.width * 0.6, // size adjustment
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
