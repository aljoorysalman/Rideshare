import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare/view/ride/home_view.dart';

class CancelButton extends StatelessWidget {
  final String id;             // requestID or rideID
  final bool isRide;           // true = ride, false = request

  const CancelButton({
    super.key,
    required this.id,
    required this.isRide,
  });

  Future<void> _cancel(BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    if (isRide) {
      // Cancel a ride
      await _firestore.collection("rides").doc(id).update({
        "status": "cancelled",
        "cancelledBy": FirebaseAuth.instance.currentUser!.uid,
        "cancelledAt": Timestamp.now(),
      });
    } else {
      // Cancel a request
      await _firestore.collection("ride_requests").doc(id).update({
        "status": "cancelled",
        "cancelledAt": Timestamp.now(),
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () => _cancel(context),
      
      child: Text(isRide ? "Cancel Ride" : "Cancel Request"),
    );
  }
}
