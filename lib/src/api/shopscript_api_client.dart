import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../exceptions/shopscript_exception.dart';

/// Main API client for ShopScript
///
/// Handles all HTTP requests to ShopScript backend with authentication,
/// error handling, and request/response interceptors.
class ShopScriptApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final Logger _logger;

  String? _baseUrl;
  String? _accessToken;
  String? _refreshToken;

  ShopScriptApiClient({Dio? dio, FlutterSecureStorage? storage, Logger? logger})
    : _dio = dio ?? Dio(),
      _storage = storage ?? const FlutterSecureStorage(),
      _logger = logger ?? Logger() {
    _setupInterceptors();
  }

  /// Initialize the API client with base URL and optional configuration
  Future<void> initialize({
    required String baseUrl,
    Map<String, String>? headers,
    int connectionTimeout = 30000,
    int receiveTimeout = 30000,
  }) async {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

    _dio.options = BaseOptions(
      baseUrl: _baseUrl!,
      connectTimeout: Duration(milliseconds: connectionTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      },
    );

    // Try to restore saved tokens
    await _restoreTokens();
  }

  /// Setup request/response interceptors
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization header if token exists
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }

          _logger.d('Request: ${options.method} ${options.path}');
          _logger.d('Headers: ${options.headers}');
          _logger.d('Data: ${options.data}');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          _logger.d('Data: ${response.data}');

          return handler.next(response);
        },
        onError: (error, handler) async {
          _logger.e(
            'Error: ${error.response?.statusCode} ${error.requestOptions.path}',
          );
          _logger.e('Message: ${error.message}');
          _logger.e('Data: ${error.response?.data}');

          // Handle token expiration
          if (error.response?.statusCode == 401) {
            if (_refreshToken != null) {
              try {
                await _refreshAccessToken();
                // Retry the original request
                final response = await _dio.fetch(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                await clearTokens();
                return handler.reject(
                  DioException(
                    requestOptions: error.requestOptions,
                    error: SessionExpiredException(),
                  ),
                );
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// Make a GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Make a POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Make a PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Make a DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Make a PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Store authentication tokens
  Future<void> storeTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    await _storage.write(key: 'access_token', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
  }

  /// Restore tokens from storage
  Future<void> _restoreTokens() async {
    _accessToken = await _storage.read(key: 'access_token');
    _refreshToken = await _storage.read(key: 'refresh_token');
  }

  /// Clear stored tokens
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;

    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  /// Refresh access token using refresh token
  Future<void> _refreshAccessToken() async {
    if (_refreshToken == null) {
      throw SessionExpiredException();
    }

    final response = await _dio.post(
      '/api/auth/refresh',
      data: {'refresh_token': _refreshToken},
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      await storeTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String?,
      );
    } else {
      throw SessionExpiredException();
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _accessToken != null;

  /// Get current access token
  String? get accessToken => _accessToken;

  /// Get base URL
  String? get baseUrl => _baseUrl;

  /// Handle API errors and convert to appropriate exceptions
  ShopScriptException _handleError(DioException error) {
    final response = error.response;

    if (response == null) {
      return NetworkException(
        'Network error: ${error.message}',
        originalError: error,
        stackTrace: error.stackTrace,
      );
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    String message = 'An error occurred';

    if (data is Map<String, dynamic>) {
      message =
          data['message'] as String? ?? data['error'] as String? ?? message;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message,
          statusCode: statusCode,
          originalError: error,
          stackTrace: error.stackTrace,
        );
      case 401:
        return AuthenticationException(
          message,
          statusCode: statusCode,
          originalError: error,
          stackTrace: error.stackTrace,
        );
      case 404:
        return NotFoundException(message);
      case 422:
        Map<String, List<String>>? errors;
        if (data is Map<String, dynamic> && data['errors'] != null) {
          errors = (data['errors'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
              key,
              (value as List).map((e) => e.toString()).toList(),
            ),
          );
        }
        return ValidationException(
          message,
          errors: errors,
          statusCode: statusCode,
          originalError: error,
          stackTrace: error.stackTrace,
        );
      case 429:
        final retryAfter = response.headers.value('retry-after');
        return RateLimitException(
          retryAfter: retryAfter != null ? int.tryParse(retryAfter) : null,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          message,
          statusCode: statusCode,
          originalError: error,
          stackTrace: error.stackTrace,
        );
      default:
        return ShopScriptException(
          message,
          statusCode: statusCode,
          originalError: error,
          stackTrace: error.stackTrace,
        );
    }
  }
}
