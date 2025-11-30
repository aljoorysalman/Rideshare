import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmergencyController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SAVE OR UPDATE EMERGENCY CONTACT

  Future<void> saveEmergencyContact({
    required String studentID,
    required String emergencyPhone,
  }) async {
    await _firestore.collection("students").doc(studentID).update({
      "emergencyContact": emergencyPhone,
    });
  }

  // GET EMERGENCY CONTACT FOR STUDENT
  
  Future<String?> getEmergencyContact(String studentID) async {
    final doc =
        await _firestore.collection("students").doc(studentID).get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    final emergencyPhone = data["emergencyContact"];

    if (emergencyPhone == null || emergencyPhone.isEmpty) {
      return null;
    }

    return emergencyPhone;
  }

  // TRIGGER EMERGENCY → CALL CONTACT + SAVE TO FIRESTORE
  Future<void> triggerEmergency({
    required String studentID,
    required String driverID,
    required String rideID,
    required LatLng location,
  }) async {
    //  Get saved emergency contact
    final emergencyPhone = await getEmergencyContact(studentID);
    if (emergencyPhone == null) {
      print("No emergency contact found!");
      return;
    }

    //  Call phone number
    final Uri callUri = Uri.parse("tel:$emergencyPhone");
    await launchUrl(callUri);

    //  Save emergency event
    final emergencyID = _firestore.collection("emergencies").doc().id;

    await _firestore.collection("emergencies").doc(emergencyID).set({
      "emergencyID": emergencyID,
      "studentID": studentID,
      "driverID": driverID,
      "rideID": rideID,
      "location": GeoPoint(location.latitude, location.longitude),
      "timestamp": Timestamp.now(),
      "status": "open",
    });
  }

  // 5) RESOLVE EMERGENCY
  Future<void> resolveEmergency(String emergencyID) async {
    await _firestore.collection("emergencies").doc(emergencyID).update({
      "status": "resolved",
    });
  }
}
