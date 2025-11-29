class StudentModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String studentID;
  final String uid;            // Firebase Auth UID (important!)
  final String? profileImage;  // optional

  StudentModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.studentID,
    this.profileImage,
  });

  // Convert model → Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'studentID': studentID,
      'profileImage': profileImage,
      'createdAt': DateTime.now(),
    };
  }

  // Convert Firestore → model
  factory StudentModel.fromMap(Map<String, dynamic> data) {
    return StudentModel(
      uid: data['uid'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? '',
      studentID: data['studentID'] ?? '',
      profileImage: data['profileImage'],
    );
  }
}

