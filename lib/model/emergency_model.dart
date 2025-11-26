import 'package:cloud_firestore/cloud_firestore.dart';


class Emergency {
  final String emergencyID;
  final String studentID;
  final String driverID;
  final String rideID;
  final GeoPoint location;
  final Timestamp timestamp;
  final String status; // open / resolved

  Emergency({
    required this.emergencyID,
    required this.studentID,
    required this.driverID,
    required this.rideID,
    required this.location,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "emergencyID": emergencyID,
      "studentID": studentID,
      "driverID": driverID,
      "rideID": rideID,
      "location": location,
      "timestamp": timestamp,
      "status": status,
    };
  }

  factory Emergency.fromMap(Map<String, dynamic> map) {
    return Emergency(
      emergencyID: map["emergencyID"],
      studentID: map["studentID"],
      driverID: map["driverID"],
      rideID: map["rideID"],
      location: map["location"],
      timestamp: map["timestamp"],
      status: map["status"],
    );
  }
}
