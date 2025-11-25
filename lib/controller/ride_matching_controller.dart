import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/ride_request_model.dart';
import '../model/driver_model.dart';

class RideMatchingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const double homeToCampusRadiusKm = 7.0;

  double _distanceInKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double R = 6371;
    final double dLat = (lat2 - lat1) * pi / 180;
    final double dLon = (lon2 - lon1) * pi / 180;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  Future<List<DriverModel>> findMatchesForRequest(
    RideRequestModel request,
  ) async {
    final query = await _firestore
        .collection('drivers')
        .where('direction', isEqualTo: request.direction)
        .where('isAvailable', isEqualTo: true)
        .get();

    final List<DriverModel> allDrivers = query.docs
        .map((doc) => DriverModel.fromJson(doc.id, doc.data()))
        .toList();

    final List<_DriverWithDistance> filtered = [];

    for (final driver in allDrivers) {
      double distance;

      if (request.direction == 'HomeToCampus') {
        distance = _distanceInKm(
          request.pickupLat,
          request.pickupLng,
          driver.startLat,
          driver.startLng,
        );

        if (distance > homeToCampusRadiusKm) continue;
      } else if (request.direction == 'CampusToHome') {
        distance = _distanceInKm(
          request.dropoffLat,
          request.dropoffLng,
          driver.startLat,
          driver.startLng,
        );
      } else {
        continue;
      }

      filtered.add(
        _DriverWithDistance(driver: driver, distance: distance),
      );
    }

    filtered.sort((a, b) => a.distance.compareTo(b.distance));
    return filtered.map((e) => e.driver).toList();
  }
}

class _DriverWithDistance {
  final DriverModel driver;
  final double distance;

  _DriverWithDistance({
    required this.driver,
    required this.distance,
});
}