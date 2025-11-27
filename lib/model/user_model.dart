class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String gender;
  final String studentID;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.studentID,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      phone: data['phone'],
      gender: data['gender'],
      studentID: data['studentID'],
    );
  }
}

