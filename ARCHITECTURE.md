# Flutter ShopScript Architecture

## Overview

Flutter ShopScript is built following clean architecture principles with clear separation of concerns. The library is designed to be modular, testable, and maintainable.

## Architecture Layers

```
┌─────────────────────────────────────────────────────┐
│                   Presentation                       │
│  (Providers, UI State Management)                    │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│                   Services                           │
│  (Business Logic, High-level Operations)             │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│                      API                             │
│  (REST API Clients, HTTP Communication)              │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│                    Models                            │
│  (Data Transfer Objects, Entities)                   │
└─────────────────────────────────────────────────────┘
```

## Directory Structure

```
lib/
├── src/
│   ├── api/                      # API Layer
│   │   ├── shopscript_api_client.dart  # Base HTTP client
│   │   ├── auth_api.dart         # Authentication endpoints
│   │   ├── product_api.dart      # Product catalog endpoints
│   │   ├── cart_api.dart         # Shopping cart endpoints
│   │   ├── order_api.dart        # Order management endpoints
│   │   └── checkout_api.dart     # Checkout endpoints
│   │
│   ├── models/                   # Data Models
│   │   ├── product_models.dart   # Product entities
│   │   ├── cart_models.dart      # Cart entities
│   │   ├── customer_models.dart  # Customer entities
│   │   ├── auth_models.dart      # Auth DTOs
│   │   └── order_models.dart     # Order entities
│   │
│   ├── services/                 # Business Logic
│   │   ├── auth_service.dart     # Authentication service
│   │   └── cart_service.dart     # Cart service
│   │
│   ├── providers/                # State Management
│   │   └── shopscript_provider.dart  # Main provider
│   │
│   ├── exceptions/               # Exception Classes
│   │   └── shopscript_exception.dart  # Custom exceptions
│   │
│   └── flutter_shopscript_core.dart   # Core singleton
│
└── flutter_shopscript.dart       # Public API exports
```

## Core Components

### 1. FlutterShopScriptCore

The main singleton class that provides centralized access to all functionality.

**Responsibilities:**
- Initialize the library
- Manage API client instances
- Provide access to services
- Maintain global state

**Usage:**
```dart
final core = FlutterShopScriptCore.instance;
await core.initialize(baseUrl: 'https://store.com');
```

### 2. ShopScriptApiClient

Base HTTP client using Dio for all network requests.

**Features:**
- Automatic token management
- Request/response interceptors
- Error handling
- Token refresh logic
- Secure storage integration

**Flow:**
```
Request → Add Auth Header → Send Request → Handle Response
                                ↓
                           Error? → Retry with refreshed token
```

### 3. API Classes

Individual API classes for different domains:

- **AuthApi**: Authentication operations
- **ProductApi**: Product catalog operations
- **CartApi**: Shopping cart operations
- **OrderApi**: Order management
- **CheckoutApi**: Checkout and payment

**Pattern:**
```dart
class ProductApi {
  final ShopScriptApiClient _client;
  
  ProductApi(this._client);
  
  Future<Product> getProduct(int id) async {
    final response = await _client.get('/api/products/$id');
    return Product.fromJson(response.data);
  }
}
```

### 4. Services

High-level business logic with state management.

**Features:**
- ChangeNotifier integration
- Loading states
- Error handling
- Reactive updates

**Pattern:**
```dart
class AuthService extends ChangeNotifier {
  final AuthApi _authApi;
  
  Customer? _currentCustomer;
  bool _isLoading = false;
  String? _error;
  
  Future<void> login({...}) async {
    _setLoading(true);
    try {
      final response = await _authApi.login(...);
      _currentCustomer = response.customer;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
```

### 5. Models

Immutable data classes using Freezed.

**Features:**
- Immutability
- JSON serialization
- copyWith methods
- Equality comparison

**Pattern:**
```dart
@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    required double price,
    // ... other fields
  }) = _Product;
  
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
```

### 6. Providers

State management using Provider pattern.

**Features:**
- Centralized state
- Dependency injection
- Reactive UI updates

**Usage:**
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ShopScriptProvider()),
  ],
  child: MyApp(),
)
```

### 7. Exception Handling

Structured exception hierarchy for better error handling.

**Hierarchy:**
```
ShopScriptException (base)
├── AuthenticationException
│   ├── InvalidCredentialsException
│   └── SessionExpiredException
├── NetworkException
├── ValidationException
├── NotFoundException
│   ├── ProductNotFoundException
│   └── OrderNotFoundException
├── ServerException
├── CartException
├── PaymentException
└── CheckoutException
```

## Design Patterns

### 1. Singleton Pattern

Used in `FlutterShopScriptCore` for global access.

```dart
class FlutterShopScriptCore {
  static FlutterShopScriptCore? _instance;
  
  static FlutterShopScriptCore get instance {
    _instance ??= FlutterShopScriptCore._();
    return _instance!;
  }
  
  FlutterShopScriptCore._();
}
```

### 2. Repository Pattern

API classes act as repositories for data access.

```dart
abstract class Repository<T> {
  Future<T> get(int id);
  Future<List<T>> getAll();
  Future<T> create(T entity);
  Future<T> update(T entity);
  Future<void> delete(int id);
}
```

### 3. Factory Pattern

Used in model creation from JSON.

```dart
factory Product.fromJson(Map<String, dynamic> json) =>
    _$ProductFromJson(json);
```

### 4. Observer Pattern

ChangeNotifier for reactive state management.

```dart
class CartService extends ChangeNotifier {
  void _updateCart(Cart cart) {
    _cart = cart;
    notifyListeners(); // Notify all listeners
  }
}
```

### 5. Strategy Pattern

Different authentication strategies (email/password, social login).

```dart
abstract class AuthStrategy {
  Future<AuthResponse> authenticate();
}

class EmailPasswordAuth implements AuthStrategy {
  @override
  Future<AuthResponse> authenticate() async {
    // Email/password authentication
  }
}

class SocialAuth implements AuthStrategy {
  @override
  Future<AuthResponse> authenticate() async {
    // Social authentication
  }
}
```

## Data Flow

### 1. Initialization Flow

```
App Start
    ↓
Initialize Core
    ↓
Setup API Client
    ↓
Initialize Services
    ↓
Restore Session (if exists)
    ↓
Load Initial Data
    ↓
App Ready
```

### 2. Authentication Flow

```
User Input (Email/Password)
    ↓
AuthService.login()
    ↓
AuthApi.login()
    ↓
ShopScriptApiClient.post()
    ↓
Server Response
    ↓
Store Tokens
    ↓
Update Customer State
    ↓
Notify Listeners
    ↓
UI Updates
```

### 3. Shopping Cart Flow

```
User Action (Add to Cart)
    ↓
CartService.addToCart()
    ↓
CartApi.addToCart()
    ↓
ShopScriptApiClient.post()
    ↓
Server Response
    ↓
Update Cart State
    ↓
Notify Listeners
    ↓
UI Updates (Cart Badge, Cart Screen)
```

### 4. Error Handling Flow

```
API Request
    ↓
Error Occurs
    ↓
Catch in Interceptor
    ↓
Token Expired? → Refresh Token → Retry Request
    ↓
Map to Custom Exception
    ↓
Propagate to Service
    ↓
Service Catches & Updates Error State
    ↓
UI Shows Error
```

## State Management

### Provider Pattern

```dart
// Provider setup
ChangeNotifierProvider(
  create: (_) => ShopScriptProvider(),
)

// Access in UI
Consumer<ShopScriptProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }
    return ProductList(products: provider.products);
  },
)
```

### State Types

1. **Loading State**: Show loading indicators
2. **Success State**: Display data
3. **Error State**: Show error messages
4. **Empty State**: No data available

## Security

### 1. Token Storage

- Secure storage using FlutterSecureStorage
- Encrypted on device
- Automatic cleanup on logout

### 2. HTTPS Enforcement

All API calls use HTTPS by default.

### 3. Input Validation

- Client-side validation
- Server-side validation
- Sanitization of user input

### 4. Token Refresh

- Automatic token refresh on expiration
- Retry failed requests with new token
- Fallback to login if refresh fails

## Testing Strategy

### 1. Unit Tests

Test individual functions and classes in isolation.

```dart
test('Product.fromJson creates valid product', () {
  final json = {'id': 1, 'name': 'Test', 'price': 9.99};
  final product = Product.fromJson(json);
  expect(product.id, 1);
  expect(product.name, 'Test');
});
```

### 2. Integration Tests

Test API integration and service interactions.

```dart
testWidgets('Login flow works correctly', (tester) async {
  // Setup
  final authService = AuthService(mockAuthApi);
  
  // Execute
  await authService.login(email: 'test@example.com', password: 'pass');
  
  // Verify
  expect(authService.isAuthenticated, true);
});
```

### 3. Widget Tests

Test UI components.

```dart
testWidgets('ProductCard displays product info', (tester) async {
  await tester.pumpWidget(ProductCard(product: testProduct));
  expect(find.text(testProduct.name), findsOneWidget);
});
```

## Performance Considerations

### 1. Lazy Loading

Load data on demand rather than upfront.

### 2. Caching

Cache frequently accessed data in memory.

### 3. Pagination

Implement pagination for large lists.

### 4. Image Optimization

Image caching is implemented using `cached_network_image` package for efficient image loading:

- **Automatic caching**: Images are cached locally on device
- **Placeholder support**: Loading indicators during image fetch
- **Error handling**: Fallback widgets for failed loads
- **Memory management**: Automatic cleanup and size limits
- **Offline support**: Previously loaded images available offline

See [IMAGE_CACHING.md](doc/IMAGE_CACHING.md) for detailed implementation guide.

### 5. Debouncing

Debounce search queries to reduce API calls.

## Extensibility

The architecture is designed to be easily extended:

### Adding New API Endpoint

1. Add method to appropriate API class
2. Create/update models if needed
3. Add service method if high-level logic needed
4. Update provider if UI state needed

### Adding New Feature

1. Create models in `models/`
2. Create API class in `api/`
3. Create service in `services/`
4. Create provider in `providers/`
5. Update core to expose new functionality

## Best Practices

1. **Single Responsibility**: Each class has one clear purpose
2. **Dependency Injection**: Pass dependencies through constructors
3. **Immutability**: Use immutable models with Freezed
4. **Error Handling**: Always handle errors gracefully
5. **Type Safety**: Use strong typing throughout
6. **Documentation**: Document public APIs
7. **Testing**: Write tests for critical functionality
8. **Code Generation**: Use code generation for repetitive code
9. **Async/Await**: Use async/await for asynchronous operations
10. **Null Safety**: Leverage Dart's null safety features

## Conclusion

Flutter ShopScript follows clean architecture principles with clear separation of concerns, making it maintainable, testable, and extensible. The modular design allows developers to use only what they need while providing a complete e-commerce solution out of the box.

