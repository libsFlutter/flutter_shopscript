/// Base exception class for ShopScript errors
class ShopScriptException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final dynamic originalError;
  final StackTrace? stackTrace;

  ShopScriptException(
    this.message, {
    this.code,
    this.statusCode,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('ShopScriptException: $message');
    if (code != null) buffer.write(' (Code: $code)');
    if (statusCode != null) buffer.write(' [HTTP $statusCode]');
    return buffer.toString();
  }
}

/// Network-related exceptions
class NetworkException extends ShopScriptException {
  NetworkException(
    String message, {
    String? code,
    int? statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message,
         code: code,
         statusCode: statusCode,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// Authentication exceptions
class AuthenticationException extends ShopScriptException {
  AuthenticationException(
    String message, {
    String? code,
    int? statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message,
         code: code ?? 'auth_error',
         statusCode: statusCode,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// Invalid credentials exception
class InvalidCredentialsException extends AuthenticationException {
  InvalidCredentialsException()
    : super(
        'Invalid email or password',
        code: 'invalid_credentials',
        statusCode: 401,
      );
}

/// Session expired exception
class SessionExpiredException extends AuthenticationException {
  SessionExpiredException()
    : super(
        'Session has expired. Please login again.',
        code: 'session_expired',
        statusCode: 401,
      );
}

/// Validation exceptions
class ValidationException extends ShopScriptException {
  final Map<String, List<String>>? errors;

  ValidationException(
    String message, {
    this.errors,
    String? code,
    int? statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message,
         code: code ?? 'validation_error',
         statusCode: statusCode ?? 422,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// Not found exception
class NotFoundException extends ShopScriptException {
  NotFoundException(String message)
    : super(message, code: 'not_found', statusCode: 404);
}

/// Product not found exception
class ProductNotFoundException extends NotFoundException {
  ProductNotFoundException(String productId)
    : super('Product with ID $productId not found');
}

/// Order not found exception
class OrderNotFoundException extends NotFoundException {
  OrderNotFoundException(String orderId)
    : super('Order with ID $orderId not found');
}

/// Server exception
class ServerException extends ShopScriptException {
  ServerException(
    String message, {
    String? code,
    int? statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message,
         code: code ?? 'server_error',
         statusCode: statusCode ?? 500,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// Rate limit exception
class RateLimitException extends ShopScriptException {
  final int? retryAfter;

  RateLimitException({this.retryAfter})
    : super(
        'Rate limit exceeded. Please try again later.',
        code: 'rate_limit',
        statusCode: 429,
      );
}

/// Cart exception
class CartException extends ShopScriptException {
  CartException(
    String message, {
    String? code,
    int? statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message,
         code: code ?? 'cart_error',
         statusCode: statusCode,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// Payment exception
class PaymentException extends ShopScriptException {
  PaymentException(
    String message, {
    String? code,
    int? statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message,
         code: code ?? 'payment_error',
         statusCode: statusCode,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}

/// Checkout exception
class CheckoutException extends ShopScriptException {
  CheckoutException(
    String message, {
    String? code,
    int? statusCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message,
         code: code ?? 'checkout_error',
         statusCode: statusCode,
         originalError: originalError,
         stackTrace: stackTrace,
       );
}
