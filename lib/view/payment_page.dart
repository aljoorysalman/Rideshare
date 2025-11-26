import 'package:flutter/material.dart';
import '../controller/payment_controller.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

enum PaymentMethod {
  card,
  applePay,
  stcPay,
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? selectedMethod = PaymentMethod.card;

  final PaymentController paymentController = PaymentController();

  Future<void> processPayment() async {
    final method = selectedMethod.toString();

    final error = await paymentController.processPayment(method);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful!")),
      );

      Navigator.pushNamed(context, '/rating');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const Center(
                  child: Text(
                    "Payment",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Trip Total",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "SAR 45.00",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Select payment method",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 15),

                _buildMethodTile(
                  title: "Card",
                  subtitle: "Pay with debit / credit card",
                  icon: Icons.credit_card,
                  method: PaymentMethod.card,
                ),

                const SizedBox(height: 10),

                _buildMethodTile(
                  title: "Apple Pay",
                  subtitle: "Use Apple Pay on your device",
                  icon: Icons.phone_iphone,
                  method: PaymentMethod.applePay,
                ),

                const SizedBox(height: 10),

                _buildMethodTile(
                  title: "STC Pay",
                  subtitle: "Pay using STC Pay wallet",
                  icon: Icons.account_balance_wallet,
                  method: PaymentMethod.stcPay,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required PaymentMethod method,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        setState(() {
          selectedMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selectedMethod == method ? Colors.black : Colors.grey.shade300,
            width: selectedMethod == method ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Radio<PaymentMethod>(
              value: method,
              groupValue: selectedMethod,
              activeColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
