
class RideRequestModel {
  final String requestID;            // auto-generated doc ID
  final String pickupAddress;
  final String dropoffAddress;

  final double pickupLat;
  final double pickupLng;

  final double dropoffLat;
  final double dropoffLng;

  final String direction;           // HomeToCampus / CampusToHome
  final String riderId;             // student who requested

  final String status;              // pending / matched / expired
  final String driverId;            // filled when driver accepts
  final DateTime timestamp;

  RideRequestModel({
    required this.requestID,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.direction,
    required this.riderId,
    required this.timestamp,
    this.status = "pending",
    this.driverId = "",
  });


  // TO FIREBASE

  Map<String, dynamic> toMap() {
    return {
      "pickupAddress": pickupAddress,
      "dropoffAddress": dropoffAddress,
      "pickupLat": pickupLat,
      "pickupLng": pickupLng,
      "dropoffLat": dropoffLat,
      "dropoffLng": dropoffLng,
      "direction": direction,
      "riderId": riderId,
      "timestamp": timestamp.toIso8601String(),
      "status": status,
      "driverId": driverId,
    };
  }

  // FROM FIREBASE

  factory RideRequestModel.fromMap(String id, Map<String, dynamic> map) {
    return RideRequestModel(
      requestID: id,
      pickupAddress: map["pickupAddress"] ?? "",
      dropoffAddress: map["dropoffAddress"] ?? "",
      pickupLat: (map["pickupLat"] as num).toDouble(),
      pickupLng: (map["pickupLng"] as num).toDouble(),
      dropoffLat: (map["dropoffLat"] as num).toDouble(),
      dropoffLng: (map["dropoffLng"] as num).toDouble(),
      direction: map["direction"] ?? "",
      riderId: map["riderId"] ?? "",
      timestamp: DateTime.parse(map["timestamp"]),
      status: map["status"] ?? "pending",
      driverId: map["driverId"] ?? "",
    );
  }
}
