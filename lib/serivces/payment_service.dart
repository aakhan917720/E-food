import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  static Future<PaymentIntent> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {

    return PaymentIntent.fromJson({
      'id': 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
      'client_secret': 'mock_client_secret_${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'currency': currency,
      'status': 'requires_payment_method',
      'livemode': false,
      'capture_method': 'automatic',
      'confirmation_method': 'automatic',
      'created': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });
  }
}