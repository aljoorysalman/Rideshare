import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideshare/model/driver_model.dart';
import 'package:rideshare/model/emergency_contact_model.dart';
import 'package:rideshare/model/emergency_model.dart';


class EmergencyController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SAVE OR UPDATE EMERGENCY CONTACT
  
  Future<void> saveEmergencyContact(EmergencyContact contact) async {
    await _firestore
        .collection("emergencyContacts")
        .doc(contact.studentID)
        .set(contact.toMap());
  }

  // GET EMERGENCY CONTACT FOR STUDENT
 
  Future<EmergencyContact?> getEmergencyContact(String studentID) async {
    final doc = await _firestore.collection("emergencyContacts").doc(studentID).get();

    if (!doc.exists) return null;

    return EmergencyContact.fromMap(doc.data()!);
  }

  // TRIGGER EMERGENCY → CALL CONTACT + SAVE TO FIRESTORE

  Future<void> triggerEmergency({
    required String studentID,
    required String driverID,
    required String rideID,
    required LatLng location,
  }) async {
    //  Get saved emergency contact
    final contact = await getEmergencyContact(studentID);
    if (contact == null) {
      print("No emergency contact found!");
      return;
    }

    //  Call phone number
    final Uri callUri = Uri.parse("tel:${contact.phoneNumber}");
    await launchUrl(callUri);

    //  Save emergency event
    final emergencyID = _firestore.collection("emergencies").doc().id;

    final emergency = Emergency(
      emergencyID: emergencyID,
      studentID: studentID,
      driverID: driverID,
      rideID: rideID,
      location: GeoPoint(location.latitude, location.longitude),
      timestamp: Timestamp.now(),
      status: "open",
    );

    await _firestore.collection("emergencies").doc(emergencyID).set(emergency.toMap());
  }

 

  // 5) RESOLVE EMERGENCY

  Future<void> resolveEmergency(String emergencyID) async {
    await _firestore.collection("emergencies").doc(emergencyID).update({
      "status": "resolved",
    });
  }
}
