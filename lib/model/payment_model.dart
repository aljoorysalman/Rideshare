class PaymentModel {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final double amount;

  PaymentModel({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    required this.amount,
  });

  // تحويل البيانات إلى JSON (للدفع الوهمي أو الفايربيس)
  Map<String, dynamic> toJson() {
    return {
      "cardNumber": cardNumber,
      "cardHolder": cardHolder,
      "expiryDate": expiryDate,
      "cvv": cvv,
      "amount": amount,
      "status": "success",
    };
  }
}