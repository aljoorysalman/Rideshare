import 'package:rideshare/model/payment_model.dart';

class PaymentController {
  // يتأكد من أن البيانات المدخلة صحيحة
  bool validatePayment(PaymentModel payment) {
    if (payment.cardNumber.isEmpty ||
        payment.cardHolder.isEmpty ||
        payment.expiryDate.isEmpty ||
        payment.cvv.isEmpty) {
      return false;
    }
    if (payment.cardNumber.length < 12) return false;
    if (payment.cvv.length != 3) return false;

    return true;
  }

  // ينفذ عملية دفع مزيفة
  String processPayment(PaymentModel payment) {
    bool isValid = validatePayment(payment);

    if (isValid) {
      return "Payment Successful";
    } else {
      return "Payment Failed – Invalid Input";
    }
  }
}