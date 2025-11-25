class RideRequestModel {
  final String pickupAddress;
  final String dropoffAddress;

  final double pickupLat;
  final double pickupLng;

  final double dropoffLat;
  final double dropoffLng;

  final String direction; // "HomeToCampus" or "CampusToHome"
  final String riderId;

  final DateTime timestamp;

  RideRequestModel({
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.direction,
    required this.riderId,
    required this.timestamp,
  });

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
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
    };
  }

  // Convert from JSON (optional)
  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      pickupAddress: json["pickupAddress"],
      dropoffAddress: json["dropoffAddress"],
      pickupLat: (json["pickupLat"] as num).toDouble(),
      pickupLng: (json["pickupLng"] as num).toDouble(),
      dropoffLat: (json["dropoffLat"] as num).toDouble(),
      dropoffLng: (json["dropoffLng"] as num).toDouble(),
      direction: json["direction"],
      riderId: json["riderId"],
      timestamp: DateTime.parse(json["timestamp"]),
);
}
}