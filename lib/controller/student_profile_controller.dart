// lib/controller/student_profile_controller.dart

import 'package:rideshare/model/student_profile_model.dart';

class StudentProfileController {
  Future<StudentProfile> getStudentProfile() async {
    // تقدرون لاحقاً تربطونه بفايربيس لو حابين
    return StudentProfile(
      name: "Lama Student",
      email: "4420xxxx@qu.edu.sa",
      phone: "+9665xxxxxxx",
      pastTrips: [
        "Al Nakheel → Imam University",
        "Al Sahafah → Imam University",
        "Al Yarmouk → Imam University",
      ],
    );
  }

  Future<void> updatePhone(StudentProfile profile, String newPhone) async {
    // حالياً نحدّثه محلياً بس
    profile.phone = newPhone;
    // لو تبين، نضيف هنا مستقبلاً تخزين في Firestore
  }
}