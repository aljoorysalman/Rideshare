import 'package:flutter/material.dart';

//  Centralized color palette for the entire RideShare app
class AppColors {
  // 🔹 Primary brand color (your purple tone)
  static const Color primary = Color.fromARGB(255, 91, 89, 94);

  // 🔹 Backgrounds
  static const Color background = Colors.white;
  static const Color darkBackground = Colors.black;
  static const Color greyBackground = Color.fromARGB(255, 63, 63, 63);
  static const Color lightGreyBackground = Colors.grey;

  // 🔹 Text colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color.fromARGB(255, 63, 63, 63);
  static const Color textthird = Colors.grey;

  // 🔹 Accent & feedback colors
  static const Color success = Color(0xFF4CAF50); // green
  static const Color error = Color(0xFFE53935);   // red
  static const Color warning = Color(0xFFFFC107); // yellow
}
