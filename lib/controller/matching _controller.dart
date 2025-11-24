

// ignore_for_file: file_names

import 'dart:math';
import'package:rideshare/model/data_ model.dart';



class MatchingController {
  // ignore: constant_identifier_names
  static const double _R = 6371; // نصف قطر الأرض بالكيلومتر
  static const double maxDistanceKm = 7.0; 
  static const double _campusCenterLat = 24.4716; 
  static const double _campusCenterLon = 39.6083;
  static const double _campusRadiusKm = 3.0; 

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
  
  double _calculateDistanceKm(Location loc1, Location loc2) {
    final lat1Rad = _degreesToRadians(loc1.latitude);
    final lon1Rad = _degreesToRadians(loc1.longitude);
    final lat2Rad = _degreesToRadians(loc2.latitude);
    final lon2Rad = _degreesToRadians(loc2.longitude);

    final dlat = lat2Rad - lat1Rad;
    final dlon = lon2Rad - lon1Rad;

    final a = pow(sin(dlat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(dlon / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _R * c;
  }
  
  bool _isCampusPickup(Location pickupLocation) {
    final campusCenter = Location(_campusCenterLat, _campusCenterLon);
    final distanceToCenter = _calculateDistanceKm(pickupLocation, campusCenter);
    return distanceToCenter <= _campusRadiusKm;
  }

  /// الدالة الرئيسية لتطبيق فلتر الـ 7 كم للمناطق خارج الحرم الجامعي (Non-Campus).
  List<Driver> applyDistanceFilter({
    required Location pickupLocation,
    required List<Driver> availableDrivers,
  }) {
    final isNonCampus = !_isCampusPickup(pickupLocation);

    if (!isNonCampus) {
      // إذا كانت النقطة داخل الكامبوس، يتم تجاوز الفلتر
      return availableDrivers; 
    }

    final filteredDrivers = <Driver>[];
    
    // تطبيق الفلتر
    for (var driver in availableDrivers) {
      final distance = _calculateDistanceKm(
        pickupLocation, 
        driver.location,
      );

      if (distance <= maxDistanceKm) {
        driver.distanceToPickup = double.parse(distance.toStringAsFixed(2));
        filteredDrivers.add(driver);
      }
    }

    return filteredDrivers;
  }
}