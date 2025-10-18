import 'package:flutter/foundation.dart';
import '../api/auth_api.dart';
import '../models/auth_models.dart';
import '../models/customer_models.dart';
import '../exceptions/shopscript_exception.dart';

/// Authentication service
///
/// High-level service for managing authentication and customer session
class AuthService extends ChangeNotifier {
  final AuthApi _authApi;

  Customer? _currentCustomer;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  AuthService(this._authApi);

  /// Current authenticated customer
  Customer? get currentCustomer => _currentCustomer;

  /// Check if user is authenticated
  bool get isAuthenticated => _isAuthenticated;

  /// Check if authentication is in progress
  bool get isLoading => _isLoading;

  /// Last error message
  String? get error => _error;

  /// Login customer
  Future<AuthResponse> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authApi.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      _currentCustomer = response.customer;
      _isAuthenticated = true;
      notifyListeners();

      return response;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Register new customer
  Future<Customer> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final request = CustomerRegistrationRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      final customer = await _authApi.register(request: request);
      return customer;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Get current customer information
  Future<Customer> getCurrentCustomer() async {
    _setLoading(true);
    _clearError();

    try {
      final customer = await _authApi.getCurrentCustomer();
      _currentCustomer = customer;
      _isAuthenticated = true;
      notifyListeners();

      return customer;
    } catch (e) {
      _setError(e.toString());
      _isAuthenticated = false;
      _currentCustomer = null;
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Update customer profile
  Future<Customer> updateCustomer({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    DateTime? birthDate,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final request = CustomerUpdateRequest(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        birthDate: birthDate,
      );

      final customer = await _authApi.updateCustomer(request: request);
      _currentCustomer = customer;
      notifyListeners();

      return customer;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authApi.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Request password reset
  Future<void> resetPassword({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      await _authApi.resetPassword(email: email);
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout customer
  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      await _authApi.logout();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _currentCustomer = null;
      _isAuthenticated = false;
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Check authentication status
  Future<bool> checkAuthStatus() async {
    try {
      _isAuthenticated = _authApi.isAuthenticated();

      if (_isAuthenticated && _currentCustomer == null) {
        await getCurrentCustomer();
      }

      return _isAuthenticated;
    } catch (e) {
      _isAuthenticated = false;
      _currentCustomer = null;
      notifyListeners();
      return false;
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
