import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> login(String id, String pass) async {
    try {
      
      final query = await FirebaseFirestore.instance
          .collection('students')
          .where('studentID', isEqualTo: id)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return "Student ID not found";
      }

      final data = query.docs.first.data();
      final email = data['email'];
      final realPass = data['password'];

     
      if (pass != realPass) {
        return "Wrong password";
      }

     
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: realPass,
      );

      return null; 
    } catch (e) {
      return "Login failed: $e";
    }
  }
}
