import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  String userID;
  String name;
  String email;
  String phone;
  String gender;

  String licenseNumber;
  String vehicleType;                 // sedan / SUV / van
  String carModel;                    // Toyota Camry 2020
  String carColor;                    // white
  String plateNumber;                 // XYZ-1234

  String status;                      // online / offline / onTrip
  double rating;

  GeoPoint? location;                 // ⭐ live location
  String? currentTripID;              // ⭐ for accepted ride tracking

  DriverModel({
    required this.userID,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,

    required this.licenseNumber,
    required this.vehicleType,
    required this.carModel,
    required this.carColor,
    required this.plateNumber,

    required this.status,
    required this.rating,

    this.location,
    this.currentTripID,
  });

  // ----------------------------
  // Firestore → Model
  // ----------------------------
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',

      licenseNumber: map['licenseNumber'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      carModel: map['carModel'] ?? '',
      carColor: map['carColor'] ?? '',
      plateNumber: map['plateNumber'] ?? '',

      status: map['status'] ?? 'offline',
      rating: (map['rating'] ?? 0).toDouble(),

      location: map['location'] is GeoPoint ? map['location'] : null,
      currentTripID: map['currentTripID'],
    );
  }

  // ----------------------------
  // Model → Firestore
  // ----------------------------
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,

      'licenseNumber': licenseNumber,
      'vehicleType': vehicleType,
      'carModel': carModel,
      'carColor': carColor,
      'plateNumber': plateNumber,

      'status': status,
      'rating': rating,

      'location': location,
      'currentTripID': currentTripID,
    };
  }
}
