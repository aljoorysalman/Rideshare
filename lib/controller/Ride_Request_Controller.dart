import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ride_request_model.dart';
import 'dart:math' as math;

class RideRequestController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // CAMPUS COORDINATES

  static const double campusRadiusKm = 0.5;

  static const double maleCampusLat = 24.812130;
  static const double maleCampusLng = 46.724850;

  static const double femaleCampusLat = 24.836630;
  static const double femaleCampusLng = 46.727420;

  
  // HAVERSINE

  double _distanceInKm(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    double dLat = (lat2 - lat1) * math.pi / 180;
    double dLon = (lon2 - lon1) * math.pi / 180;

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) *
            math.cos(lat2 * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  bool _isInsideCampus(double lat, double lng) {
    double male = _distanceInKm(lat, lng, maleCampusLat, maleCampusLng);
    double female = _distanceInKm(lat, lng, femaleCampusLat, femaleCampusLng);
    return male <= campusRadiusKm || female <= campusRadiusKm;
  }

  // FORM VALIDATION

  String? validateInputs({
    required String pickupAddress,
    required String dropoffAddress,
    required double? pickupLat,
    required double? pickupLng,
    required double? dropoffLat,
    required double? dropoffLng,
  }) {
    if (pickupAddress.isEmpty || dropoffAddress.isEmpty) {
      return "Please fill all fields.";
    }
    if (pickupLat == null || pickupLng == null) return "Missing pickup location.";
    if (dropoffLat == null || dropoffLng == null) return "Missing dropoff location.";
    return null;
  }

  // DETECT TRIP TYPE

  String detectDirection({
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
  }) {
    bool pickupInCampus = _isInsideCampus(pickupLat, pickupLng);
    bool dropoffInCampus = _isInsideCampus(dropoffLat, dropoffLng);

    if (pickupInCampus) return "CampusToHome";
    if (dropoffInCampus) return "HomeToCampus";
    return "Undefined";
  }


  // CREATE RideRequestModel

  RideRequestModel createRequest({
    required String requestID,
    required String pickupAddress,
    required String dropoffAddress,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required String riderId,
  }) {
    return RideRequestModel(
      requestID: requestID,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
      direction: detectDirection(
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropoffLat: dropoffLat,
        dropoffLng: dropoffLng,
      ),
      riderId: riderId,
      timestamp: DateTime.now(),
    );
  }



  String generateRequestID() { return FirebaseFirestore.instance.collection("ride_requests").doc().id;}
  




  // SAVE REQUEST TO FIREBASE


  Future<void> saveToFirebase(RideRequestModel request) async {
    await _firestore
        .collection("ride_requests")
        .doc(request.requestID)
        .set(request.toMap());
  }
}

