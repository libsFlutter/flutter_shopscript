import '../models/cart_models.dart';
import '../exceptions/shopscript_exception.dart';
import 'shopscript_api_client.dart';

/// Cart API for ShopScript
///
/// Handles shopping cart operations
class CartApi {
  final ShopScriptApiClient _client;

  CartApi(this._client);

  /// Get current cart
  ///
  /// Returns [Cart] object with items and totals
  Future<Cart> getCart() async {
    try {
      final response = await _client.get('/api/cart');

      if (response.statusCode == 200 && response.data != null) {
        return Cart.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw CartException('Failed to fetch cart');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to fetch cart: $e');
    }
  }

  /// Add item to cart
  ///
  /// Returns updated [Cart]
  Future<Cart> addToCart({
    required int productId,
    int quantity = 1,
    String? variantId,
    Map<String, dynamic>? options,
  }) async {
    try {
      final response = await _client.post(
        '/api/cart/items',
        data: {
          'product_id': productId,
          'quantity': quantity,
          if (variantId != null) 'variant_id': variantId,
          if (options != null) 'options': options,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Cart.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw CartException('Failed to add item to cart');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to add item to cart: $e');
    }
  }

  /// Update cart item quantity
  ///
  /// Returns updated [Cart]
  Future<Cart> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await _client.put(
        '/api/cart/items/$itemId',
        data: {'quantity': quantity},
      );

      if (response.statusCode == 200) {
        return Cart.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw CartException('Failed to update cart item');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to update cart item: $e');
    }
  }

  /// Remove item from cart
  ///
  /// Returns updated [Cart]
  Future<Cart> removeFromCart(String itemId) async {
    try {
      final response = await _client.delete('/api/cart/items/$itemId');

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.data != null) {
          return Cart.fromJson(response.data as Map<String, dynamic>);
        } else {
          // If no data returned, fetch cart
          return getCart();
        }
      } else {
        throw CartException('Failed to remove item from cart');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to remove item from cart: $e');
    }
  }

  /// Clear cart
  ///
  /// Removes all items from cart
  Future<void> clearCart() async {
    try {
      final response = await _client.delete('/api/cart');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw CartException('Failed to clear cart');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to clear cart: $e');
    }
  }

  /// Apply coupon to cart
  ///
  /// Returns updated [Cart] with discount applied
  Future<Cart> applyCoupon(String couponCode) async {
    try {
      final response = await _client.post(
        '/api/cart/coupon',
        data: {'coupon_code': couponCode},
      );

      if (response.statusCode == 200) {
        return Cart.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw CartException('Failed to apply coupon');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to apply coupon: $e');
    }
  }

  /// Remove coupon from cart
  ///
  /// Returns updated [Cart] without discount
  Future<Cart> removeCoupon() async {
    try {
      final response = await _client.delete('/api/cart/coupon');

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.data != null) {
          return Cart.fromJson(response.data as Map<String, dynamic>);
        } else {
          return getCart();
        }
      } else {
        throw CartException('Failed to remove coupon');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to remove coupon: $e');
    }
  }

  /// Get cart totals
  ///
  /// Returns [CartTotals] with detailed breakdown
  Future<CartTotals> getCartTotals() async {
    try {
      final response = await _client.get('/api/cart/totals');

      if (response.statusCode == 200 && response.data != null) {
        return CartTotals.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw CartException('Failed to fetch cart totals');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to fetch cart totals: $e');
    }
  }

  /// Get available shipping methods
  ///
  /// Returns list of [ShippingMethod]
  Future<List<ShippingMethod>> getShippingMethods() async {
    try {
      final response = await _client.get('/api/cart/shipping-methods');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final methods =
            data['data'] as List? ?? data['shipping_methods'] as List? ?? [];
        return methods
            .map((e) => ShippingMethod.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw CartException('Failed to fetch shipping methods');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to fetch shipping methods: $e');
    }
  }

  /// Get available payment methods
  ///
  /// Returns list of [PaymentMethod]
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await _client.get('/api/cart/payment-methods');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final methods =
            data['data'] as List? ?? data['payment_methods'] as List? ?? [];
        return methods
            .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw CartException('Failed to fetch payment methods');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw CartException('Failed to fetch payment methods: $e');
    }
  }
}
