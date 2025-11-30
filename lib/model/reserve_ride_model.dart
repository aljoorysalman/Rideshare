class ReserveRideModel {
  final String pickupAddress;
  final String dropoffAddress;

  final double pickupLat;
  final double pickupLng;

  final double dropoffLat;
  final double dropoffLng;

  final DateTime scheduledTime; // وقت الرحلة المحجوزة
  final String riderId;         // الطالبة
  final String? driverId;       // السائق (اختياري)
  final String direction;       // HomeToCampus / CampusToHome

  final int seats;              // عدد المقاعد
  final String status;          // pending / confirmed / cancelled

  final DateTime createdAt;     // وقت إنشاء الحجز

  ReserveRideModel({
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.scheduledTime,
    required this.riderId,
    this.driverId,
    required this.direction,
    required this.seats,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "pickupAddress": pickupAddress,
      "dropoffAddress": dropoffAddress,
      "pickupLat": pickupLat,
      "pickupLng": pickupLng,
      "dropoffLat": dropoffLat,
      "dropoffLng": dropoffLng,
      "scheduledTime": scheduledTime.toIso8601String(),
      "riderId": riderId,
      "driverId": driverId,
      "direction": direction,
      "seats": seats,
      "status": status,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory ReserveRideModel.fromJson(Map<String, dynamic> json) {
    return ReserveRideModel(
      pickupAddress: json["pickupAddress"],
      dropoffAddress: json["dropoffAddress"],
      pickupLat: (json["pickupLat"] as num).toDouble(),
      pickupLng: (json["pickupLng"] as num).toDouble(),
      dropoffLat: (json["dropoffLat"] as num).toDouble(),
      dropoffLng: (json["dropoffLng"] as num).toDouble(),
      scheduledTime: DateTime.parse(json["scheduledTime"]),
      riderId: json["riderId"],
      driverId: json["driverId"],
      direction: json["direction"],
      seats: json["seats"],
      status: json["status"],
      createdAt: DateTime.parse(json["createdAt"]),
);
}
}