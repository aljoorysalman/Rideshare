// lib/model/student_profile_model.dart

class StudentProfile {
  String name;
  String email;
  String phone;
  List<String> pastTrips;

  StudentProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.pastTrips,
  });
}