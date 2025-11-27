import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
     
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user!.emailVerified) {
         
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          
          Navigator.pushReplacementNamed(context, '/verify');
        }
      }
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'img/car.png',
            height: 100,
            color: Colors.white,
          ),

          SizedBox(height: 20),

          Text(
            'RideShare',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 10),

          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}
}
