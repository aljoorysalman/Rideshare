import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyContact {
  final String contactID;
  final String studentID;
  final String contactName;
  final String phoneNumber;
  final String relation; // mother, father, sister, friend

  EmergencyContact({
    required this.contactID,
    required this.studentID,
    required this.contactName,
    required this.phoneNumber,
    required this.relation,
  });

  Map<String, dynamic> toMap() {
    return {
      "contactID": contactID,
      "studentID": studentID,
      "contactName": contactName,
      "phoneNumber": phoneNumber,
      "relation": relation,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      contactID: map["contactID"],
      studentID: map["studentID"],
      contactName: map["contactName"],
      phoneNumber: map["phoneNumber"],
      relation: map["relation"],
    );
  }
}
