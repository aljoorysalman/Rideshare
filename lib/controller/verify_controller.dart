import 'package:firebase_auth/firebase_auth.dart';

class VerifyController {
  
  Future<void> sendVerificationEmail() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  
  Future<bool> checkIfVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    return user != null && user.emailVerified;
  }
}
