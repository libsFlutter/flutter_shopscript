import '../models/order_models.dart';
import '../exceptions/shopscript_exception.dart';
import 'shopscript_api_client.dart';

/// Order API for ShopScript
///
/// Handles order operations and history
class OrderApi {
  final ShopScriptApiClient _client;

  OrderApi(this._client);

  /// Get customer orders
  ///
  /// Returns [OrderListResponse] with orders and pagination
  Future<OrderListResponse> getOrders({int page = 1, int pageSize = 20}) async {
    try {
      final response = await _client.get(
        '/api/orders',
        queryParameters: {'page': page, 'limit': pageSize},
      );

      if (response.statusCode == 200 && response.data != null) {
        return OrderListResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ShopScriptException('Failed to fetch orders');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch orders: $e');
    }
  }

  /// Get order by ID
  ///
  /// Returns [Order] object
  Future<Order> getOrder(int orderId) async {
    try {
      final response = await _client.get('/api/orders/$orderId');

      if (response.statusCode == 200 && response.data != null) {
        return Order.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw OrderNotFoundException(orderId.toString());
      } else {
        throw ShopScriptException('Failed to fetch order');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch order: $e');
    }
  }

  /// Get order by order number
  ///
  /// Returns [Order] object
  Future<Order> getOrderByNumber(String orderNumber) async {
    try {
      final response = await _client.get('/api/orders/number/$orderNumber');

      if (response.statusCode == 200 && response.data != null) {
        return Order.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw OrderNotFoundException(orderNumber);
      } else {
        throw ShopScriptException('Failed to fetch order');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch order: $e');
    }
  }

  /// Cancel order
  ///
  /// Returns updated [Order]
  Future<Order> cancelOrder({required int orderId, String? reason}) async {
    try {
      final response = await _client.post(
        '/api/orders/$orderId/cancel',
        data: {if (reason != null) 'reason': reason},
      );

      if (response.statusCode == 200 && response.data != null) {
        return Order.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ShopScriptException('Failed to cancel order');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to cancel order: $e');
    }
  }

  /// Reorder - create new cart from existing order
  ///
  /// Returns order ID
  Future<int> reorder(int orderId) async {
    try {
      final response = await _client.post('/api/orders/$orderId/reorder');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return data['order_id'] as int? ?? data['id'] as int;
      } else {
        throw ShopScriptException('Failed to reorder');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to reorder: $e');
    }
  }

  /// Track order shipment
  ///
  /// Returns tracking information
  Future<Map<String, dynamic>> trackOrder(int orderId) async {
    try {
      final response = await _client.get('/api/orders/$orderId/tracking');

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ShopScriptException('Failed to get tracking info');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to get tracking info: $e');
    }
  }
}
