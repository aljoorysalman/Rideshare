import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'view/login_page.dart';
import 'view/splashview.dart';
import 'view/dashboard_page.dart';
import 'view/register_page.dart';
import 'view/verify_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: SplashView(),

      routes: {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  '/verify': (context) => const VerifyPage(),
  '/dashboard': (context) => const DashboardPage(),
},

    );
  }
}