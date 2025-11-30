// lib/model/student_profile_model.dart

class StudentProfile {
  String name;
  String email;
  String phone;
  String emergencyContact;
  List<String> pastTrips;

  StudentProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.pastTrips,
    required this.emergencyContact,

  });

  /// 
  /// Convert Firestore document to StudentProfile object
  /// 
  factory StudentProfile.fromMap(Map<String, dynamic> data) {
    return StudentProfile(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      pastTrips: List<String>.from(data['pastTrips'] ?? []),
      emergencyContact: data['emergencyContact'] ?? '',
    );
  }

  /// 
  /// Convert StudentProfile object to Firestore data (Map)
  /// 
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'pastTrips': pastTrips,
      'emergencyContact': emergencyContact,
    };
  }
}
