class DriverModel {
  final String driverId;
  final String name;
  final double startLat;
  final double startLng;
  final String direction; // "HomeToCampus" أو "CampusToHome"
  final bool isAvailable;
  final int seats;

  DriverModel({
    required this.driverId,
    required this.name,
    required this.startLat,
    required this.startLng,
    required this.direction,
    required this.isAvailable,
    required this.seats,
  });

  factory DriverModel.fromJson(String id, Map<String, dynamic> json) {
    return DriverModel(
      driverId: id,
      name: (json['name'] ?? '') as String,
      startLat: (json['startLat'] as num).toDouble(),
      startLng: (json['startLng'] as num).toDouble(),
      direction: json['direction'] as String,
      isAvailable: (json['isAvailable'] ?? true) as bool,
      seats: (json['seats'] ?? 1) as int,
    );
  }
Map<String, dynamic> toJson(){
  return{
    'name': name,
    'startLat': startLat,
    'startLng': startLng,
    'direction': direction,
    'isAvailable': isAvailable,
    'seats':seats,
  };
} 
}