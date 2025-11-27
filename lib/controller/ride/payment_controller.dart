import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentController {
  Future<String?> processPayment(String method) async {
    try {
      double price = 45.0; 

      await FirebaseFirestore.instance.collection('payments').add({
        'method': method,
        'amount': price,
        'status': 'success',
        'createdAt': Timestamp.now(),
      });

      return null; 
    } catch (e) {
      return "Payment failed: $e";
    }
  }
}
