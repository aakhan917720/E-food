class PaymentService {
  static Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    // Mock response - Real implementation ke liye backend API call karo
    return {
      'id': 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
      'clientSecret': 'mock_client_secret_${DateTime.now().millisecondsSinceEpoch}',
    };
  }
}