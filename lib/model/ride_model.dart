import 'package:cloud_firestore/cloud_firestore.dart';

class RideModel {
  final String rideID;

  final GeoPoint pickupLocation;
  final String pickupAddress;

  final GeoPoint dropoffLocation;
  final String dropoffAddress;      // REQUIRED for Campus→Home grouping

  final String direction;           // HomeToCampus / CampusToHome

  final String status;              // waiting, assigned, onRoute, arrived, completed
  final double fare;

  final DateTime scheduledTime;
  final int pickupPIN;

  final String driverID;
  final List<String> studentIDs;

  RideModel({
    required this.rideID,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.dropoffLocation,
    required this.dropoffAddress,
    required this.direction,
    required this.status,
    required this.fare,
    required this.scheduledTime,
    required this.pickupPIN,
    required this.driverID,
    required this.studentIDs,
  });

  // ----------------------- FROM FIRESTORE -----------------------
  factory RideModel.fromMap(String id, Map<String, dynamic> map) {
    return RideModel(
      rideID: id,
      pickupLocation: map['pickupLocation'] as GeoPoint,
      pickupAddress: map['pickupAddress'] ?? '',

      dropoffLocation: map['dropoffLocation'] as GeoPoint,
      dropoffAddress: map['dropoffAddress'] ?? '',

      direction: map['direction'] ?? '',

      status: map['status'] ?? 'waiting',
      fare: (map['fare'] ?? 0).toDouble(),

      scheduledTime: map['scheduledTime'] is Timestamp
          ? (map['scheduledTime'] as Timestamp).toDate()
          : DateTime.parse(map['scheduledTime']),

      pickupPIN: map['pickupPIN'] ?? 0,

      driverID: map['driverID'] ?? '',
      studentIDs: List<String>.from(map['studentIDs'] ?? []),
    );
  }

  // ----------------------- TO FIRESTORE -----------------------
  Map<String, dynamic> toMap() {
    return {
      'pickupLocation': pickupLocation,
      'pickupAddress': pickupAddress,

      'dropoffLocation': dropoffLocation,
      'dropoffAddress': dropoffAddress,

      'direction': direction,

      'status': status,
      'fare': fare,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'pickupPIN': pickupPIN,

      'driverID': driverID,
      'studentIDs': studentIDs,
    };
  }
}
