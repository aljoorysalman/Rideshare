import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rideshare/model/ride/reserve_ride_model.dart';

class ReserveRideController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String collectionName = "reserved_rides";

  // ------------------------------
  // 1) VALIDATION
  // ------------------------------
  String? validateReserveInputs({
    required String pickupAddress,
    required String dropoffAddress,
    required double? pickupLat,
    required double? pickupLng,
    required double? dropoffLat,
    required double? dropoffLng,
    required DateTime? scheduledTime,
    required int seats,
  }) {
    if (pickupAddress.isEmpty || dropoffAddress.isEmpty) {
      return "Please fill all addresses.";
    }

    if (pickupLat == null || pickupLng == null) {
      return "Pickup location is missing.";
    }

    if (dropoffLat == null || dropoffLng == null) {
      return "Drop-off location is missing.";
    }

    if (scheduledTime == null) {
      return "Please choose a reservation time.";
    }

    if (scheduledTime.isBefore(DateTime.now())) {
      return "Reservation time must be in the future.";
    }

    if (seats <= 0) {
      return "Seats must be at least 1.";
    }

    return null;
  }

  // ------------------------------
  // 2) CREATE RESERVATION MODEL
  // ------------------------------
  ReserveRideModel createReservation({
    required String pickupAddress,
    required String dropoffAddress,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required DateTime scheduledTime,
    required String riderId,
    String? driverId,
    required String direction,
    required int seats,
  }) {
    return ReserveRideModel(
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
      scheduledTime: scheduledTime,
      riderId: riderId,
      driverId: driverId,
      direction: direction,
      seats: seats,
      status: "pending",
      createdAt: DateTime.now(),
    );
  }

  // ------------------------------
  // 3) SAVE RESERVATION IN FIREBASE
  // ------------------------------
  Future<void> saveReservation(ReserveRideModel reservation) async {
    await _firestore.collection(collectionName).add(reservation.toJson());
  }

  // ------------------------------
  // 4) UPDATE STATUS
  // ------------------------------
  Future<void> updateStatus({
    required String reservationId,
    required String newStatus,
  }) async {
    await _firestore.collection(collectionName).doc(reservationId).update({
      "status": newStatus,
    });
  }

  // ------------------------------
  // 5) CANCEL RESERVATION
  // ------------------------------
  Future<void> cancelReservation(String reservationId) async {
    await updateStatus(reservationId: reservationId, newStatus: "cancelled");
}
}