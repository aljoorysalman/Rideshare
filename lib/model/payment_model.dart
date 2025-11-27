class PaymentModel {
  final String method;
  final double amount;

  PaymentModel({
    required this.method,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'amount': amount,
      'createdAt': DateTime.now(),
      'status': 'success',
    };
  }
}
