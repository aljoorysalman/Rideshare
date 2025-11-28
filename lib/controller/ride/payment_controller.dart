import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/ride/payment_model.dart';

class PaymentController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _paymentsRef =>
      _firestore.collection('payments');

  /// تُستخدم من صفحة الدفع:
  /// ترجع null إذا نجحت العملية، أو نص برسالة الخطأ إذا فشلت
  Future<String?> processPayment(String methodString) async {
    try {
      // يحول "PaymentMethod.card" إلى "card" مثلاً
      final method = methodString.split('.').last;

      // نتأكد إن المستخدم مسجل دخول
      final user = _auth.currentUser;
      if (user == null) {
        return 'User is not logged in';
      }

      // 🔹 TODO: هنا حطي القيم الصح اللي عندكم من الرحلة
      // مؤقتًا حطيت قيم ثابتة عشان ما يكسر الكود
      const String rideId = 'ride_temp_id';      // استبدليه بالـ rideId الحقيقي
      const String driverId = 'driver_temp_id';  // استبدليه بالـ driverId الحقيقي
      const double amount = 45.0;                // نفس اللي ظاهر في الشاشة "SAR 45.00"

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
      return null; // null يعني ما فيه خطأ

    } catch (e) {
      print('❌ Error processing payment: $e');
      return 'Failed to process payment. Please try again.';
    }
  }

  /// اختياري: تجيب مدفوعات الرحلة (ممكن تحتاجينها لعرض التفاصيل)
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

  /// اختياري: مدفوعات طالب معيّن (ممكن تستخدمينها في البروفايل)
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