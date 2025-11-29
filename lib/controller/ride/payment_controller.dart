import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/ride/payment_model.dart';

class PaymentController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _paymentsRef =>
      _firestore.collection('payments');


  /// PROCESS PAYMENT
  /// Returns:
  ///   null => success
  ///   String => error message
  
  Future<String?> processPayment({
    required String methodString,
    required String rideId,
    required String driverId,
    required double amount,
  }) async {
    try {
      // Clean method → example: "PaymentMethod.card" → "card"
      final method = methodString.split('.').last;

      final user = _auth.currentUser;
      if (user == null) return 'User is not logged in';

      final payment = PaymentModel(
        rideId: rideId,
        userId: user.uid,
        driverId: driverId,
        method: method,
        amount: amount,
        createdAt: DateTime.now(),
      );

      await _paymentsRef.add(payment.toMap());
      print('✅ Payment added successfully');
      return null;

    } catch (e) {
      print('❌ Error processing payment: $e');
      return 'Failed to process payment. Please try again.';
    }
  }

  /// 
  /// GET PAYMENTS FOR SPECIFIC RIDE
  /// 
  Future<List<PaymentModel>> getPaymentsForRide(String rideId) async {
    try {
      final query = await _paymentsRef
          .where("rideId", isEqualTo: rideId)
          .get();

      return query.docs
          .map((doc) => PaymentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("❌ Error fetching payments: $e");
      return [];
    }
  }

  /// 
  /// GET PAYMENTS FOR SPECIFIC USER
  /// 
  Future<List<PaymentModel>> getUserPayments(String userId) async {
    try {
      final query = await _paymentsRef
          .where("userId", isEqualTo: userId)
          .get();

      return query.docs
          .map((doc) => PaymentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("❌ Error fetching user payments: $e");
      return [];
    }
  }
}
