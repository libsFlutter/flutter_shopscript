import '../models/order_models.dart';
import '../exceptions/shopscript_exception.dart';
import 'shopscript_api_client.dart';

/// Checkout API for ShopScript
///
/// Handles checkout and order placement
class CheckoutApi {
  final ShopScriptApiClient _client;

  CheckoutApi(this._client);

  /// Place order
  ///
  /// Creates order from cart and returns [CheckoutResponse]
  Future<CheckoutResponse> placeOrder({
    required CheckoutRequest request,
  }) async {
    try {
      final response = await _client.post(
        '/api/checkout',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CheckoutResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw CheckoutException('Failed to place order');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CheckoutException('Failed to place order: $e');
    }
  }

  /// Validate checkout data
  ///
  /// Validates addresses and payment information before placing order
  Future<Map<String, dynamic>> validateCheckout({
    required CheckoutRequest request,
  }) async {
    try {
      final response = await _client.post(
        '/api/checkout/validate',
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw CheckoutException('Checkout validation failed');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CheckoutException('Checkout validation failed: $e');
    }
  }

  /// Process payment
  ///
  /// Processes payment for an order
  Future<Map<String, dynamic>> processPayment({
    required int orderId,
    required String paymentMethodId,
    Map<String, dynamic>? paymentData,
  }) async {
    try {
      final response = await _client.post(
        '/api/checkout/payment',
        data: {
          'order_id': orderId,
          'payment_method_id': paymentMethodId,
          if (paymentData != null) 'payment_data': paymentData,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw PaymentException('Payment processing failed');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw PaymentException('Payment processing failed: $e');
    }
  }

  /// Confirm payment
  ///
  /// Confirms payment after external payment gateway processing
  Future<Order> confirmPayment({
    required int orderId,
    required String paymentToken,
  }) async {
    try {
      final response = await _client.post(
        '/api/checkout/payment/confirm',
        data: {'order_id': orderId, 'payment_token': paymentToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        return Order.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw PaymentException('Payment confirmation failed');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw PaymentException('Payment confirmation failed: $e');
    }
  }
}
