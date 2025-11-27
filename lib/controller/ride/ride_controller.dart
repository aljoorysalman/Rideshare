import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rideshare/model/ride/ride_model.dart';

class RideController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate 4-digit PIN
  int generatePickupPIN() {
    return 1000 + Random().nextInt(9000);
  }

  //
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

    final ride = RideModel(
      rideID: rideID,
      pickupLocation: pickupLocation,
      pickupAddress: pickupAddress,

      dropoffLocation: dropoffLocation,
      dropoffAddress: dropoffAddress,

      direction: direction,
      status: "assigned",

      fare: 0.0,
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
