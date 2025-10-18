import '../models/auth_models.dart';
import '../models/customer_models.dart';
import '../exceptions/shopscript_exception.dart';
import 'shopscript_api_client.dart';

/// Authentication API for ShopScript
///
/// Handles customer authentication, registration, and session management
class AuthApi {
  final ShopScriptApiClient _client;

  AuthApi(this._client);

  /// Login customer with email and password
  ///
  /// Returns [AuthResponse] with access token and customer data
  Future<AuthResponse> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await _client.post(
        '/api/auth/login',
        data: {'email': email, 'password': password, 'remember_me': rememberMe},
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        // Store tokens in client
        await _client.storeTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );

        return authResponse;
      } else {
        throw AuthenticationException('Login failed');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw AuthenticationException('Login failed: $e');
    }
  }

  /// Register new customer
  ///
  /// Returns [Customer] object for newly created customer
  Future<Customer> register({
    required CustomerRegistrationRequest request,
  }) async {
    try {
      final response = await _client.post(
        '/api/auth/register',
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Customer.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw AuthenticationException('Registration failed');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw AuthenticationException('Registration failed: $e');
    }
  }

  /// Get current customer information
  ///
  /// Requires authentication
  Future<Customer> getCurrentCustomer() async {
    try {
      final response = await _client.get('/api/customer/me');

      if (response.statusCode == 200 && response.data != null) {
        return Customer.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw AuthenticationException('Failed to get customer data');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw AuthenticationException('Failed to get customer data: $e');
    }
  }

  /// Update customer profile
  ///
  /// Requires authentication
  Future<Customer> updateCustomer({
    required CustomerUpdateRequest request,
  }) async {
    try {
      final response = await _client.put(
        '/api/customer/me',
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Customer.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw AuthenticationException('Failed to update customer');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw AuthenticationException('Failed to update customer: $e');
    }
  }

  /// Change customer password
  ///
  /// Requires authentication
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _client.post(
        '/api/customer/password/change',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw AuthenticationException('Failed to change password');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw AuthenticationException('Failed to change password: $e');
    }
  }

  /// Request password reset
  ///
  /// Sends password reset email to customer
  Future<void> resetPassword({required String email}) async {
    try {
      final response = await _client.post(
        '/api/auth/password/reset',
        data: {'email': email},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw AuthenticationException('Failed to request password reset');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw AuthenticationException('Failed to request password reset: $e');
    }
  }

  /// Logout current customer
  ///
  /// Clears tokens and invalidates session
  Future<void> logout() async {
    try {
      await _client.post('/api/auth/logout');
    } catch (e) {
      // Continue even if logout request fails
    } finally {
      // Always clear local tokens
      await _client.clearTokens();
    }
  }

  /// Check if customer is authenticated
  bool isAuthenticated() {
    return _client.isAuthenticated;
  }

  /// Refresh authentication token
  ///
  /// Uses refresh token to get new access token
  Future<TokenRefreshResponse> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _client.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final tokenResponse = TokenRefreshResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        // Update stored tokens
        await _client.storeTokens(
          accessToken: tokenResponse.accessToken,
          refreshToken: tokenResponse.refreshToken,
        );

        return tokenResponse;
      } else {
        throw AuthenticationException('Failed to refresh token');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw AuthenticationException('Failed to refresh token: $e');
    }
  }

  /// Social login (e.g., Google, Facebook)
  ///
  /// Returns [AuthResponse] with access token and customer data
  Future<AuthResponse> socialLogin({
    required String provider,
    required String token,
  }) async {
    try {
      final response = await _client.post(
        '/api/auth/social/$provider',
        data: {'token': token},
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        // Store tokens in client
        await _client.storeTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );

        return authResponse;
      } else {
        throw AuthenticationException('Social login failed');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw AuthenticationException('Social login failed: $e');
    }
  }
}
