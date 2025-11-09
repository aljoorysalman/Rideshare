import 'package:flutter/material.dart';
import 'package:rideshare/view/ride/home_view.dart';
import 'package:rideshare/view/chat/communication_view.dart';
import 'package:rideshare/view/profile/profile_view.dart';
import 'package:rideshare/view/splashview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
      routes: {
        '/home': (context) => const HomeView(),
        '/communication': (context) => const CommunicationView(),
        '/profile': (context) => const ProfileView(),
      },
    );
  }
}
