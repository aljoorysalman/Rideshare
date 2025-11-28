import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'view/auth/login_view.dart';
import 'view/splashview.dart';
import 'view/auth/dashboard_view.dart';
import 'view/auth/register_view.dart';
import 'view/auth/verify_view.dart';
import 'view/payment_page.dart';
import 'view/rating_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/view/ride/ride_accepted_view.dart';
import 'firebase_options.dart';
import 'package:rideshare/view/splashview.dart';



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
  '/payment': (context) => const PaymentPage(),
  '/rating': (context) => const RatingPage(),
  '/dashboard': (context) => const DashboardPage(),
},

      //  TEMPORARY: Open AcceptedRideView directly for testing
      // home: PaymentPage(),
    );
  }
}