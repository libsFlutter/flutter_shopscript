import 'package:flutter/foundation.dart';
import '../flutter_shopscript_core.dart';
import '../models/product_models.dart';
import '../exceptions/shopscript_exception.dart';

/// Main provider for ShopScript
///
/// Manages initialization and provides access to core functionality
class ShopScriptProvider extends ChangeNotifier {
  final FlutterShopScriptCore _core = FlutterShopScriptCore.instance;

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  // Products cache
  List<Product> _products = [];
  List<ProductCategory> _categories = [];

  /// Check if library is initialized
  bool get isInitialized => _isInitialized;

  /// Check if loading
  bool get isLoading => _isLoading;

  /// Get error message
  String? get error => _error;

  /// Get core instance
  FlutterShopScriptCore get core => _core;

  /// Get cached products
  List<Product> get products => _products;

  /// Get cached categories
  List<ProductCategory> get categories => _categories;

  /// Initialize ShopScript
  Future<bool> initialize({
    required String baseUrl,
    Map<String, String>? headers,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _core.initialize(
        baseUrl: baseUrl,
        headers: headers,
      );

      _isInitialized = success;

      if (success) {
        // Load initial data
        await loadCategories();

        // Load cart if authenticated
        if (_core.isAuthenticated) {
          await _core.cartService.loadCart();
        }
      }

      notifyListeners();
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Load products
  Future<void> loadProducts({
    int page = 1,
    int pageSize = 20,
    ProductFilterParams? filters,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _core.productApi.getProducts(
        page: page,
        pageSize: pageSize,
        filters: filters,
      );

      if (page == 1) {
        _products = response.products;
      } else {
        _products.addAll(response.products);
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Load categories
  Future<void> loadCategories() async {
    try {
      _categories = await _core.productApi.getCategories();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Search products
  Future<List<Product>> searchProducts({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _core.productApi.searchProducts(
        query: query,
        page: page,
        pageSize: pageSize,
      );

      return response.products;
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
