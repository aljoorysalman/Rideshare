import'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final double rating;
  final String feedback;
  final String driverId;
  final String rideId;
  final DateTime createdAt;

  RatingModel({
    required this.rating,
    required this.feedback,
    required this.driverId,
    required this.rideId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'feedback': feedback,
      'driverId': driverId,
      'rideId': rideId,
      'timestamp': createdAt,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      rating: map['rating']?.toDouble() ?? 0.0,
      feedback: map['feedback'] ?? '',
      driverId: map['driverId'] ?? '',
      rideId: map['rideId'] ?? '',
      createdAt: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
