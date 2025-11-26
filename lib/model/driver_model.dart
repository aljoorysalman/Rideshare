import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  final String userID;
  final String name;
  final String email;
  final String phone;
  final String gender;

  final String licenseNumber;
  final String vehicleType;        // sedan, SUV, van
  final String carModel;           // Camry 2020
  final String carColor;           // white
  final String plateNumber;        // XYZ1234

  final bool isAvailable;          // required for matching
  final String direction;          // HomeToCampus / CampusToHome
  final double rating;

  final GeoPoint? location;        // live location
  final String? currentTripID;     // ride assigned to driver

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
    required this.isAvailable,
    required this.direction,
    required this.rating,
    this.location,
    this.currentTripID,
  });

// FROM FIRESTORE
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
      isAvailable: map['isAvailable'] ?? true,
      direction: map['direction'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      location: map['location'],
      currentTripID: map['currentTripID'],
    );
  }

  // TO FIRESTORE
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
      'isAvailable': isAvailable,
      'direction': direction,
      'rating': rating,
      'location': location,
      'currentTripID': currentTripID,
    };
  }
}
