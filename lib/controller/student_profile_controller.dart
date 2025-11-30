// lib/controller/student_profile_controller.dart


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rideshare/model/student_profile_model.dart';

class StudentProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  /// GET STUDENT PROFILE FROM FIRESTORE
  Future<StudentProfile> getStudentProfile() async {
    // Get current user ID
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    // Read student profile from Firestore
    final doc =
        await _firestore.collection("students").doc(user.uid).get();

    if (!doc.exists) {
      throw Exception("Student profile not found in Firestore");
    }

    final data = doc.data()!;

    return StudentProfile(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      pastTrips:
          List<String>.from(data['pastTrips'] ?? []),
      emergencyContact: data['emergencyContact'] ?? '',
    );
  }

  /// UPDATE PHONE NUMBER IN FIRESTORE
  Future<void> updatePhone(StudentProfile profile, String newPhone) async {
    final user = _auth.currentUser;
    if (user == null) return;

    profile.phone = newPhone;

    await _firestore.collection("students").doc(user.uid).update({
      "phone": newPhone,
    });

  }
  /// /// UPDATE EMERGENCY CONTACT IN FIRESTORE
Future<void> updateEmergencyContact(String newContact) async {
  final user = _auth.currentUser;
  if (user == null) return;

  await _firestore.collection("students").doc(user.uid).update({
    "emergencyContact": newContact,
  });
}


}

// TEMPORARY StudentProfileController (NO LOGIN REQUIRED)

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rideshare/model/student_profile_model.dart';

// class StudentProfileController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Test user ID (change if needed)
//   static const String testUserId = "TESTUSER1";

//   /// GET STUDENT PROFILE (NO AUTH REQUIRED)
//   Future<StudentProfile> getStudentProfile() async {
//     final doc = await _firestore.collection("students").doc(testUserId).get();

//     if (!doc.exists) {
//       throw Exception("Firestore: TESTUSER1 does not exist. Create it first.");
//     }

//     final data = doc.data()!;

//     return StudentProfile(
//       name: data['name'] ?? '',
//       email: data['email'] ?? '',
//       phone: data['phone'] ?? '',
//       pastTrips: List<String>.from(data['pastTrips'] ?? []),
//       emergencyContact: data['emergencyContact'] ?? '',
//     );
//   }

//   /// UPDATE PHONE NUMBER (NO AUTH REQUIRED)
//   Future<void> updatePhone(StudentProfile profile, String newPhone) async {
//     profile.phone = newPhone;

//     await _firestore.collection("students").doc(testUserId).update({
//       "phone": newPhone,
//     });
//   }

//   /// UPDATE EMERGENCY CONTACT (NO AUTH REQUIRED)
//   Future<void> updateEmergencyContact(String newContact) async {
//     await _firestore.collection("students").doc(testUserId).update({
//       "emergencyContact": newContact,
//     });
//   }
// }
