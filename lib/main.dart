import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

      //  TEMPORARY: Open AcceptedRideView directly for testing
      home: AcceptedRideView(
        driverID: "Uxf5zJgFui6ndkj6jgdP",    
        pickupLatLng: const LatLng(24.7136, 46.6753),  
      ),
    );
  }
}