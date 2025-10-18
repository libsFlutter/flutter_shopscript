import 'package:flutter/foundation.dart';
import 'api/shopscript_api_client.dart';
import 'api/auth_api.dart';
import 'api/product_api.dart';
import 'api/cart_api.dart';
import 'api/order_api.dart';
import 'api/checkout_api.dart';
import 'services/auth_service.dart';
import 'services/cart_service.dart';
import 'exceptions/shopscript_exception.dart';

/// Main singleton class for Flutter ShopScript library
///
/// This class provides centralized access to all ShopScript functionality through
/// a singleton pattern. It manages the core services and provides a unified
/// interface for authentication, API services, and cart operations.
///
/// ## Usage
///
/// ```dart
/// final core = FlutterShopScriptCore.instance;
///
/// // Initialize the library
/// await core.initialize(baseUrl: 'https://yourstore.com');
///
/// // Access services
/// final authService = core.authService;
/// final cartService = core.cartService;
/// ```
class FlutterShopScriptCore {
  static FlutterShopScriptCore? _instance;

  late final ShopScriptApiClient _apiClient;
  late final AuthApi _authApi;
  late final ProductApi _productApi;
  late final CartApi _cartApi;
  late final OrderApi _orderApi;
  late final CheckoutApi _checkoutApi;
  late final AuthService _authService;
  late final CartService _cartService;

  bool _isInitialized = false;
  String? _baseUrl;

  FlutterShopScriptCore._();

  /// Get singleton instance of FlutterShopScriptCore
  static FlutterShopScriptCore get instance {
    _instance ??= FlutterShopScriptCore._();
    return _instance!;
  }

  /// Initialize the library with base URL and configuration
  ///
  /// Must be called before using any other methods.
  ///
  /// [baseUrl] The base URL of your ShopScript store
  /// [headers] Optional custom headers
  /// [connectionTimeout] Connection timeout in milliseconds (default: 30000)
  /// [receiveTimeout] Receive timeout in milliseconds (default: 30000)
  ///
  /// Returns `true` if initialization was successful
  Future<bool> initialize({
    required String baseUrl,
    Map<String, String>? headers,
    int connectionTimeout = 30000,
    int receiveTimeout = 30000,
  }) async {
    try {
      _baseUrl = baseUrl;

      // Initialize API client
      _apiClient = ShopScriptApiClient();
      await _apiClient.initialize(
        baseUrl: baseUrl,
        headers: headers,
        connectionTimeout: connectionTimeout,
        receiveTimeout: receiveTimeout,
      );

      // Initialize API classes
      _authApi = AuthApi(_apiClient);
      _productApi = ProductApi(_apiClient);
      _cartApi = CartApi(_apiClient);
      _orderApi = OrderApi(_apiClient);
      _checkoutApi = CheckoutApi(_apiClient);

      // Initialize services
      _authService = AuthService(_authApi);
      _cartService = CartService(_cartApi);

      _isInitialized = true;

      // Try to restore authentication state
      await _authService.checkAuthStatus();

      debugPrint('FlutterShopScript initialized successfully');
      return true;
    } catch (e) {
      debugPrint('FlutterShopScript initialization failed: $e');
      return false;
    }
  }

  /// Check if the library is initialized
  bool get isInitialized => _isInitialized;

  /// Get the base URL
  String? get baseUrl => _baseUrl;

  /// Get API client
  ShopScriptApiClient get apiClient {
    _checkInitialized();
    return _apiClient;
  }

  /// Get auth API
  AuthApi get authApi {
    _checkInitialized();
    return _authApi;
  }

  /// Get product API
  ProductApi get productApi {
    _checkInitialized();
    return _productApi;
  }

  /// Get cart API
  CartApi get cartApi {
    _checkInitialized();
    return _cartApi;
  }

  /// Get order API
  OrderApi get orderApi {
    _checkInitialized();
    return _orderApi;
  }

  /// Get checkout API
  CheckoutApi get checkoutApi {
    _checkInitialized();
    return _checkoutApi;
  }

  /// Get auth service
  AuthService get authService {
    _checkInitialized();
    return _authService;
  }

  /// Get cart service
  CartService get cartService {
    _checkInitialized();
    return _cartService;
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    if (!_isInitialized) return false;
    return _apiClient.isAuthenticated;
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw ShopScriptException(
        'FlutterShopScript is not initialized. Call initialize() first.',
        code: 'not_initialized',
      );
    }
  }

  /// Reset the instance (useful for testing)
  @visibleForTesting
  static void reset() {
    _instance = null;
  }
}
