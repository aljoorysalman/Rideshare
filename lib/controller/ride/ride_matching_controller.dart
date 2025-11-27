import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/model/users/driver_model.dart';
import 'package:rideshare/model/ride/ride_request_model.dart';
import 'package:rideshare/controller/ride/ride_controller.dart';


class RideMatchingController {
  static const double maxPickupDistanceKm = 7.0;

  final CollectionReference driversRef =
      FirebaseFirestore.instance.collection("drivers");

  final CollectionReference ridesRef =
      FirebaseFirestore.instance.collection("rides");

  // Convert Firestore GeoPoint -> LatLng
  LatLng geoToLatLng(GeoPoint point) {
    return LatLng(point.latitude, point.longitude);
  }

  // Haversine distance
  double calculateDistanceKm(LatLng a, LatLng b) {
    const R = 6371;
    final dLat = (b.latitude - a.latitude) * pi / 180;
    final dLon = (b.longitude - a.longitude) * pi / 180;

    final lat1 = a.latitude * pi / 180;
    final lat2 = b.latitude * pi / 180;

    final aVal = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);

    return R * 2 * atan2(sqrt(aVal), sqrt(1 - aVal));
  }


  /// MAIN SUITABILITY CHECK LOGIC

  bool isDriverSuitable({
    required DriverModel driver,
    required RideRequestModel request,
    String? existingTripDropoffAddress,
  }) {
    // Must be available
    if (!driver.isAvailable) return false;

    // Must match ride direction ("HomeToCampus" / "CampusToHome")
    if (driver.direction != request.direction) return false;

    // Must have location
    if (driver.location == null) return false;

    final driverLatLng = geoToLatLng(driver.location!);
    final studentPickupLatLng =
        LatLng(request.pickupLat, request.pickupLng);


    // A) HOME → CAMPUS  (apply 7 km rule)
    
    if (request.direction == "HomeToCampus") {
      final distance = calculateDistanceKm(driverLatLng, studentPickupLatLng);
      return distance <= maxPickupDistanceKm;
    }

    // B) CAMPUS → HOME (match dropoffAddress only)

    if (request.direction == "CampusToHome") {
      // First student for driver → ALWAYS accept
      if (existingTripDropoffAddress == null ||
          existingTripDropoffAddress.isEmpty) {
        return true;
      }

      // Only accept if dropoffAddress 
     return existingTripDropoffAddress.trim().toLowerCase() ==
       request.dropoffAddress.trim().toLowerCase();

    }

    return false;
  }


  /// FIREBASE: FIND DRIVER FOR REQUEST

  Future<String?> matchDriverToStudent({
    required RideRequestModel request,
  }) async {
    final driverDocs = await driversRef.get();

    String? matchedDriver;

    for (var doc in driverDocs.docs) {
      final driver = DriverModel.fromMap(doc.data() as Map<String, dynamic>);

      // Get driver's existing active ride (if any)
      String? existingNeighborhood;

      final rideDoc = await ridesRef.doc(driver.userID).get();
      if (rideDoc.exists) {
        existingNeighborhood = rideDoc["dropoffAddress"];
      }

      // Check suitability
      final ok = isDriverSuitable(
        driver: driver,
        request: request,
        existingTripDropoffAddress: existingNeighborhood,
      );

      if (ok) {
        matchedDriver = driver.userID;
        break;
      }
    }

    return matchedDriver;
  }

Future<String> handleFullRideFlow(RideRequestModel request) async {
  // 1) Save request to Firestore
  await FirebaseFirestore.instance
      .collection("ride_requests")
      .doc(request.requestID)
      .set(request.toMap());

  // 2) Match a driver
  final String? driverID = await matchDriverToStudent(request: request);

  if (driverID == null) {
    throw "No available drivers found";
  }

  // 3) Create the ride
  final RideController rideController = RideController();

  final String rideID = await rideController.createRide(
    pickupLocation: GeoPoint(request.pickupLat, request.pickupLng),
    pickupAddress: request.pickupAddress,
    dropoffLocation: GeoPoint(request.dropoffLat, request.dropoffLng),
    dropoffAddress: request.dropoffAddress,
    direction: request.direction,
    driverID: driverID,
    studentIDs: [request.riderId],
  );

  // 4) Update request to notify WaitingView
  await FirebaseFirestore.instance
      .collection("ride_requests")
      .doc(request.requestID)
      .update({
    "status": "matched",
    "driverId": driverID,
    "rideId": rideID,
  });

  return rideID;
}


}
