 
// lib/models/data_models.dart

// ignore_for_file: file_names

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);
}

class Driver {
  final String id;
  final String name;
  final Location location;
  // لحفظ المسافة المحسوبة بعد التصفية
  double? distanceToPickup; 

  Driver({
    required this.id, 
    required this.name, 
    required this.location,
    this.distanceToPickup, 
  });
}