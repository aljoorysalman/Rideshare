import 'package:flutter/material.dart';

// This page is just a placeholder for now.
// Later, you'll design your signup UI here (form, buttons, etc.)
class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Signup Page',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
