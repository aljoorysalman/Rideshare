import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rideshare/model/ride/ride_model.dart';
import'package:google_maps_flutter/google_maps_flutter.dart';

class RideController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate 4-digit PIN
  int generatePickupPIN() {
    return 1000 + Random().nextInt(9000);
  }

   double calculateDistanceKm(LatLng a, LatLng b) {
    const R = 6371;
    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;

    final lat1 = a.latitude * pi / 180;
    final lat2 = b.latitude * pi / 180;

    final aVal = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);

    return R * 2 * atan2(sqrt(aVal), sqrt(1 - aVal));
  }
  // CREATE RIDE AFTER MATCH
  
  Future<String> createRide({
  required GeoPoint pickupLocation,
  required String pickupAddress,

  required GeoPoint dropoffLocation,
  required String dropoffAddress,

  required String direction, // HomeToCampus / CampusToHome
  required String driverID,
  required List<String> studentIDs,
}) async {
  final rideID = _firestore.collection("rides").doc().id;

  
  // 1) Calculate distance
  
  final pickupLatLng = LatLng(pickupLocation.latitude, pickupLocation.longitude);
  final dropoffLatLng = LatLng(dropoffLocation.latitude, dropoffLocation.longitude);

  final double distanceKm = calculateDistanceKm(pickupLatLng, dropoffLatLng);

  
  // 2) Calculate fare
  
  const double ratePerKm = 1.5; // Base rate
  final double totalFare = distanceKm * ratePerKm;

  // Shared price (per student)
  final int studentCount = studentIDs.length;
  final double farePerStudent =
      double.parse((totalFare / studentCount).toStringAsFixed(2));

  
  //  3) Create ride with updated fare logic
  
  final ride = RideModel(
    rideID: rideID,
    pickupLocation: pickupLocation,
    pickupAddress: pickupAddress,

    dropoffLocation: dropoffLocation,
    dropoffAddress: dropoffAddress,

    direction: direction,
    status: "assigned",

    fare: farePerStudent,                  
    totalFare: double.parse(totalFare.toStringAsFixed(2)),  
    distanceKm: distanceKm,                

    scheduledTime: DateTime.now(),
    pickupPIN: generatePickupPIN(),

    driverID: driverID,
    studentIDs: studentIDs,
  );

  await _firestore.collection("rides").doc(rideID).set(ride.toMap());
  return rideID;
}


  // ---------------------------------------------------------
  // UPDATE STATUS
  // ---------------------------------------------------------
  Future<void> updateStatus(String rideID, String status) async {
    await _firestore.collection("rides").doc(rideID).update({
      "status": status,
    });
  }

  // ---------------------------------------------------------
  // ADD STUDENT (Campus → Home grouping)
  // ---------------------------------------------------------
  Future<void> addStudent(String rideID, String studentID) async {
    await _firestore.collection("rides").doc(rideID).update({
      "studentIDs": FieldValue.arrayUnion([studentID]),
    });
  }

  // ---------------------------------------------------------
  // END RIDE
  // ---------------------------------------------------------
  Future<void> endRide(String rideID) async {
    await updateStatus(rideID, "completed");
  }

  // ---------------------------------------------------------
  // STREAM RIDE DATA
  // ---------------------------------------------------------
  Stream<RideModel?> streamRide(String rideID) {
    return _firestore.collection("rides").doc(rideID).snapshots().map((doc) {
      if (!doc.exists) return null;
      return RideModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    });
  }

Future<void> cancelRide(String rideID, String cancelledBy) async {
    await _firestore.collection("rides").doc(rideID).update({
      "status": "cancelled",
      "cancelledBy": cancelledBy,
      "cancelledAt": Timestamp.now(),
    });
  }

}