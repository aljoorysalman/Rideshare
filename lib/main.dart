import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'firebase_options.dart';

import 'view/auth/login_page.dart';
import 'view/auth/register_view.dart';
import 'view/auth/verify_view.dart';
import 'view/auth/dashboard_view.dart';
import 'view/ride/home_view.dart';
import 'view/ride/payment_page.dart';
import 'view/ride/rating_page.dart';
import 'view/ride/ride_accepted_view.dart';

import 'package:rideshare/model/ride/rating_args.dart';
import 'package:rideshare/view/ride/reserve_ride_view.dart';
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

    home:SplashView(),


    routes: {
      '/login': (_) => const LoginPage(),
      '/register': (_) => const RegisterPage(),
      '/verify': (_) => const VerifyPage(),
      '/dashboard': (_) => const DashboardPage(),
      '/home' : (_)=> const HomeView(),
    },

    onGenerateRoute: (settings) {
  if (settings.name == '/rating') {
    final args = settings.arguments as RatingArgs;

    return MaterialPageRoute(
      builder: (_) => RatingPage(
        driverId: args.driverId,
        rideId: args.rideId,
      ),
    );
  }

  return null;
},

  );
}
}