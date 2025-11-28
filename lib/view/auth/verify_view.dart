import 'package:flutter/material.dart';
import '../controller/verify_controller.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool isChecking = false;

  final VerifyController verifyController = VerifyController();

  @override
  void initState() {
    super.initState();
    verifyController.sendVerificationEmail(); 
  }

  Future<void> checkVerification() async {
    setState(() => isChecking = true);

    bool isVerified = await verifyController.checkIfVerified();

    if (isVerified) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your email is not verified yet")),
      );
    }

    setState(() => isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.email_outlined,
                size: 100,
                color: Colors.black,
              ),

              const SizedBox(height: 20),

              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),

              const Text(
                "We sent a verification link to your email.\nPlease click the link to activate your account.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isChecking ? null : checkVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isChecking
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "I verified my email",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
