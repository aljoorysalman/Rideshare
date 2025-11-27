import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rideshare/model/users/driver_model.dart';

class DriverController { 

  final CollectionReference driverRef =
      FirebaseFirestore.instance.collection("drivers");

  /// Create or update driver profile
  Future<void> saveDriver(DriverModel driver) async {
    await driverRef.doc(driver.userID).set(
          driver.toMap(),
          SetOptions(merge: true),
        );
  }

  /// Get a single driver by ID (one-time read)
  Future<DriverModel?> getDriver(String driverID) async {
    DocumentSnapshot doc = await driverRef.doc(driverID).get();
    if (!doc.exists) return null;

    return DriverModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  /// Listen to driver changes (real-time updates)
  Stream<DriverModel?> streamDriver(String driverID) {
    return driverRef.doc(driverID).snapshots().map((doc) {
      if (!doc.exists) return null;
      return DriverModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  /// Update driver status (online/offline/onTrip)
  Future<void> updateStatus(String driverID, String status) async {
    await driverRef.doc(driverID).update({
      "status": status,
    });
  }

  /// Update driver real-time location
  Future<void> updateLocation(String driverID, double lat, double lng) async {
    await driverRef.doc(driverID).update({
      "location": GeoPoint(lat, lng), 
    });
  }

  /// Update driver rating
  Future<void> updateRating(String driverID, double rating) async {
    await driverRef.doc(driverID).update({
      "rating": rating,
    });
  }

  /// Update driver's vehicle fields (plate, car type, model, color...)
  Future<void> updateVehicleInfo(String driverID, Map<String, dynamic> vehicleData) async {
    await driverRef.doc(driverID).update({
      "vehicleInfo": vehicleData,
    });
  }

  /// Attach driver to a trip
  Future<void> assignTrip(String driverID, String tripID) async {
    await driverRef.doc(driverID).update({
      "currentTripID": tripID,
      "status": "onTrip",
    });
  }

  /// Clear driver trip when ride ends
  Future<void> clearTrip(String driverID) async {
    await driverRef.doc(driverID).update({
      "currentTripID": null,
      "status": "online",
    });
  }

  /// Soft delete / disable driver account
  Future<void> disableDriver(String driverID) async {
    await driverRef.doc(driverID).update({
      "status": "disabled",
    });
  }
}