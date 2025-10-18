# 🚀 Flutter ShopScript Plugin 1.0

A comprehensive Flutter library for ShopScript e-commerce platform integration. This plugin provides modern architecture, enhanced performance, and comprehensive e-commerce functionality for building cutting-edge mobile commerce applications with ShopScript.

## 📋 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Demo Store](#-demo-store)
- [API Reference](#-api-reference)
- [Architecture](#-architecture)
- [Platform Support](#-platform-support)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### 🚀 Modern Architecture
- **Flutter 3.8+ Support**: Latest Flutter SDK with enhanced performance
- **Modular Structure**: Use only the components you need
- **Type Safety**: Strong typing with Freezed models
- **Consistency**: Same approach across all applications

### 🔐 Advanced Authentication
- JWT tokens with automatic refresh
- Secure storage with FlutterSecureStorage
- "Remember me" support
- Automatic token validation
- Session expiration handling

### 🌐 Unified Network Layer
- Dio HTTP client with automatic retries
- Internet connectivity monitoring
- Automatic error handling
- Request logging in debug mode
- Response caching

### 🛍️ E-commerce Functionality
- Full ShopScript REST API integration
- Product catalog browsing
- Shopping cart management
- Order placement and tracking
- Customer account management
- Search and filtering

### 🎨 State Management
- Provider + ChangeNotifier pattern
- Ready-made providers for all services
- Reactive UI updates
- Centralized state management

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_shopscript: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Initialize the Plugin

```dart
import 'package:flutter/material.dart';
import 'package:flutter_shopscript/flutter_shopscript.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShopScriptProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<ShopScriptProvider>(
        builder: (context, provider, child) {
          if (!provider.isInitialized) {
            return FutureBuilder(
              future: provider.initialize(
                baseUrl: 'https://asiabiopharm.com',
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return const HomePage();
              },
            );
          }
          return const HomePage();
        },
      ),
    );
  }
}
```

### 2. Authentication

```dart
// Login
final authService = FlutterShopScriptCore.instance.authService;

await authService.login(
  email: 'customer@example.com',
  password: 'password123',
  rememberMe: true,
);

// Register
await authService.register(
  email: 'new@example.com',
  password: 'password123',
  firstName: 'John',
  lastName: 'Doe',
);

// Get current customer
final customer = await authService.getCurrentCustomer();

// Logout
await authService.logout();
```

### 3. Products

```dart
final productApi = FlutterShopScriptCore.instance.productApi;

// Get products with pagination
final products = await productApi.getProducts(
  page: 1,
  pageSize: 20,
);

// Get single product
final product = await productApi.getProduct(123);

// Search products
final searchResults = await productApi.searchProducts(
  query: 'smartphone',
  page: 1,
  pageSize: 20,
);

// Get categories
final categories = await productApi.getCategories();

// Get products by category
final categoryProducts = await productApi.getProductsByCategory(
  categoryId: 456,
  page: 1,
  pageSize: 20,
);
```

### 4. Shopping Cart

```dart
final cartService = FlutterShopScriptCore.instance.cartService;

// Load cart
await cartService.loadCart();

// Add to cart
await cartService.addToCart(
  productId: 123,
  quantity: 2,
);

// Update item quantity
await cartService.updateItemQuantity(
  itemId: 'item-id',
  quantity: 3,
);

// Remove item
await cartService.removeItem('item-id');

// Apply coupon
await cartService.applyCoupon('SAVE20');

// Clear cart
await cartService.clearCart();
```

### 5. Orders

```dart
final orderApi = FlutterShopScriptCore.instance.orderApi;

// Get customer orders
final orders = await orderApi.getOrders(
  page: 1,
  pageSize: 20,
);

// Get order details
final order = await orderApi.getOrder(789);

// Cancel order
await orderApi.cancelOrder(
  orderId: 789,
  reason: 'Changed mind',
);

// Reorder
final newOrderId = await orderApi.reorder(789);
```

### 6. Checkout

```dart
final checkoutApi = FlutterShopScriptCore.instance.checkoutApi;

// Place order
final checkoutResponse = await checkoutApi.placeOrder(
  request: CheckoutRequest(
    shippingAddress: shippingAddress,
    billingAddress: billingAddress,
    shippingMethodId: 'standard',
    paymentMethodId: 'card',
    comment: 'Please deliver in the morning',
  ),
);

// Process payment
final paymentResult = await checkoutApi.processPayment(
  orderId: checkoutResponse.order.id,
  paymentMethodId: 'card',
  paymentData: {
    'card_number': '4111111111111111',
    'cvv': '123',
    'expiry': '12/25',
  },
);
```

## 🏪 Demo Store

This plugin is demonstrated with **Asiabiopharm** (https://asiabiopharm.com/en/) - a real ShopScript-powered store selling:

- Herbal preparations and remedies
- Natural cosmetics and skincare
- Essential oils and aromatherapy products
- Natural foods and supplements
- Traditional medicine products

### Running the Example

```bash
cd example
flutter run
```

The example app showcases:
- Product catalog browsing
- Category navigation
- Shopping cart management
- Product search
- Customer authentication
- Order placement

## 📚 API Reference

### Core Classes

#### FlutterShopScriptCore

Main singleton class providing access to all functionality.

```dart
final core = FlutterShopScriptCore.instance;

// Initialize
await core.initialize(baseUrl: 'https://yourstore.com');

// Access services
final authService = core.authService;
final cartService = core.cartService;

// Access APIs
final productApi = core.productApi;
final orderApi = core.orderApi;
```

#### ShopScriptProvider

Provider for state management.

```dart
ChangeNotifierProvider(
  create: (_) => ShopScriptProvider(),
)
```

### Models

All models are immutable and use Freezed for code generation:

- `Product` - Product information
- `ProductCategory` - Category information
- `Cart` - Shopping cart
- `CartItem` - Cart item
- `Customer` - Customer account
- `Order` - Order information
- `AuthResponse` - Authentication response

### Services

#### AuthService

Manages authentication and customer sessions.

```dart
// Properties
bool isAuthenticated
Customer? currentCustomer
bool isLoading
String? error

// Methods
login({email, password, rememberMe})
register({email, password, firstName, lastName})
getCurrentCustomer()
updateCustomer({email, firstName, lastName})
changePassword({currentPassword, newPassword})
resetPassword({email})
logout()
```

#### CartService

Manages shopping cart operations.

```dart
// Properties
Cart? cart
int itemCount
double subtotal
double total
bool isEmpty

// Methods
loadCart()
addToCart({productId, quantity, variantId, options})
updateItemQuantity({itemId, quantity})
removeItem(itemId)
clearCart()
applyCoupon(couponCode)
removeCoupon()
getTotals()
getShippingMethods()
getPaymentMethods()
```

### APIs

All API classes follow the same pattern:

- `AuthApi` - Authentication endpoints
- `ProductApi` - Product catalog endpoints
- `CartApi` - Shopping cart endpoints
- `OrderApi` - Order management endpoints
- `CheckoutApi` - Checkout and payment endpoints

### Exception Handling

```dart
try {
  await authService.login(email: email, password: password);
} on AuthenticationException catch (e) {
  print('Authentication error: ${e.message}');
} on NetworkException catch (e) {
  print('Network error: ${e.message}');
} on ShopScriptException catch (e) {
  print('Error: ${e.message}');
}
```

Exception types:
- `ShopScriptException` - Base exception
- `AuthenticationException` - Authentication errors
- `NetworkException` - Network errors
- `ValidationException` - Validation errors
- `NotFoundException` - Resource not found
- `ServerException` - Server errors
- `CartException` - Cart errors
- `PaymentException` - Payment errors

## 🏗️ Architecture

The plugin follows clean architecture with layered approach:

```
lib/
├── src/
│   ├── api/                 # API clients
│   │   ├── shopscript_api_client.dart
│   │   ├── auth_api.dart
│   │   ├── product_api.dart
│   │   ├── cart_api.dart
│   │   ├── order_api.dart
│   │   └── checkout_api.dart
│   ├── models/              # Data models
│   │   ├── product_models.dart
│   │   ├── cart_models.dart
│   │   ├── customer_models.dart
│   │   ├── auth_models.dart
│   │   └── order_models.dart
│   ├── services/            # Business logic
│   │   ├── auth_service.dart
│   │   └── cart_service.dart
│   ├── providers/           # State management
│   │   └── shopscript_provider.dart
│   ├── exceptions/          # Exception classes
│   │   └── shopscript_exception.dart
│   └── flutter_shopscript_core.dart
└── flutter_shopscript.dart  # Public exports
```

### Design Patterns

- **Singleton**: Core class instance
- **Provider**: State management
- **Repository**: API abstraction
- **Factory**: Model creation

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔒 Security Features

- JWT token authentication
- HTTPS enforcement
- Secure token storage (FlutterSecureStorage)
- Automatic token refresh
- Input validation

## 🧪 Testing

```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate code (for Freezed models)
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file:

```env
SHOPSCRIPT_API_URL=https://asiabiopharm.com
CONNECTION_TIMEOUT=30000
RECEIVE_TIMEOUT=30000
```

Load in your app:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

await dotenv.load(fileName: ".env");

await provider.initialize(
  baseUrl: dotenv.env['SHOPSCRIPT_API_URL'] ?? 'https://asiabiopharm.com',
);
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the NativeMindNONC License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📧 Email: support@nativemind.net
- 🐛 Issues: [GitHub Issues](https://github.com/nativemind/flutter_shopscript/issues)
- 📚 Documentation: [Wiki](https://github.com/nativemind/flutter_shopscript/wiki)

## 🙏 Acknowledgments

- ShopScript team for the excellent e-commerce platform
- Flutter team for the amazing framework
- Asiabiopharm team for the demo store partnership
- All contributors and community members

---

**Made with ❤️ by NativeMind Team**

