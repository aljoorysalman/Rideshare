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

  final double averageRating;
  final double totalRating;
  final int ratingCount;

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
    this.averageRating = 0.0,
    this.totalRating = 0.0,
    this.ratingCount = 0,
    this.location,
    this.currentTripID,
  });

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
      averageRating: (map['averageRating'] ?? 0).toDouble(),
      totalRating: (map['totalRating'] ?? 0).toDouble(),
      ratingCount: (map['ratingCount'] ?? 0).toInt(),
      location: map['location'],
      currentTripID: map['currentTripID'],
    );
  }

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
      'averageRating': averageRating,
      'totalRating': totalRating,
      'ratingCount': ratingCount,
      'location': location,
      'currentTripID': currentTripID,
    };
  }
}
