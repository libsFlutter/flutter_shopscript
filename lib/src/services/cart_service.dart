import 'package:flutter/foundation.dart';
import '../api/cart_api.dart';
import '../models/cart_models.dart';

/// Cart service
///
/// High-level service for managing shopping cart
class CartService extends ChangeNotifier {
  final CartApi _cartApi;

  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  CartService(this._cartApi);

  /// Current cart
  Cart? get cart => _cart;

  /// Cart item count
  int get itemCount => _cart?.itemCount ?? 0;

  /// Cart subtotal
  double get subtotal => _cart?.subtotal ?? 0.0;

  /// Cart total
  double get total => _cart?.total ?? 0.0;

  /// Check if cart is loading
  bool get isLoading => _isLoading;

  /// Last error message
  String? get error => _error;

  /// Check if cart is empty
  bool get isEmpty => _cart == null || _cart!.items.isEmpty;

  /// Load cart
  Future<void> loadCart() async {
    _setLoading(true);
    _clearError();

    try {
      _cart = await _cartApi.getCart();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Add product to cart
  Future<void> addToCart({
    required int productId,
    int quantity = 1,
    String? variantId,
    Map<String, dynamic>? options,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _cart = await _cartApi.addToCart(
        productId: productId,
        quantity: quantity,
        variantId: variantId,
        options: options,
      );
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Update cart item quantity
  Future<void> updateItemQuantity({
    required String itemId,
    required int quantity,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _cart = await _cartApi.updateCartItem(itemId: itemId, quantity: quantity);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove item from cart
  Future<void> removeItem(String itemId) async {
    _setLoading(true);
    _clearError();

    try {
      _cart = await _cartApi.removeFromCart(itemId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Clear all items from cart
  Future<void> clearCart() async {
    _setLoading(true);
    _clearError();

    try {
      await _cartApi.clearCart();
      _cart = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Apply coupon code
  Future<void> applyCoupon(String couponCode) async {
    _setLoading(true);
    _clearError();

    try {
      _cart = await _cartApi.applyCoupon(couponCode);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove applied coupon
  Future<void> removeCoupon() async {
    _setLoading(true);
    _clearError();

    try {
      _cart = await _cartApi.removeCoupon();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Get cart totals
  Future<CartTotals> getTotals() async {
    _setLoading(true);
    _clearError();

    try {
      final totals = await _cartApi.getCartTotals();
      return totals;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Get available shipping methods
  Future<List<ShippingMethod>> getShippingMethods() async {
    _setLoading(true);
    _clearError();

    try {
      final methods = await _cartApi.getShippingMethods();
      return methods;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Get available payment methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    _setLoading(true);
    _clearError();

    try {
      final methods = await _cartApi.getPaymentMethods();
      return methods;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
