import'package:cloud_firestore/cloud_firestore.dart';
class PaymentModel {
  final String rideId;
  final String userId;
  final String driverId;
  final String method;
  final double amount;
  final String status;
  final DateTime createdAt;

  PaymentModel({
    required this.rideId,
    required this.userId,
    required this.driverId,
    required this.method,
    required this.amount,
    this.status = "success",
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
      'userId': userId,
      'driverId': driverId,
      'method': method,
      'amount': amount,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> data) {
    return PaymentModel(
      rideId: data['rideId'],
      userId: data['userId'],
      driverId: data['driverId'],
      method: data['method'],
      amount: (data['amount'] as num).toDouble(),
      status: data['status'] ?? 'success',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
