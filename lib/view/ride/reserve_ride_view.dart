import 'package:flutter/material.dart';
import 'package:rideshare/core/constants/app_colors.dart';

class ReserveRideView extends StatelessWidget {
  const ReserveRideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, // same as page background
        elevation: 0, // remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); //  go back to previous page
          },
        ),
      ),    
      body: const Center(
        child: Text(
          'This is the Reserve Ride page',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
