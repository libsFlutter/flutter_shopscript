# Flutter ShopScript API Documentation

## Table of Contents

1. [Core API](#core-api)
2. [Authentication](#authentication)
3. [Products](#products)
4. [Cart](#cart)
5. [Orders](#orders)
6. [Checkout](#checkout)
7. [Exception Handling](#exception-handling)

## Core API

### FlutterShopScriptCore

Main singleton class providing access to all functionality.

#### Initialization

```dart
final core = FlutterShopScriptCore.instance;

await core.initialize(
  baseUrl: 'https://asiabiopharm.com',
  headers: {'X-Custom-Header': 'value'},
  connectionTimeout: 30000,
  receiveTimeout: 30000,
);
```

#### Properties

- `isInitialized: bool` - Check if library is initialized
- `baseUrl: String?` - Get the base URL
- `isAuthenticated: bool` - Check if user is authenticated
- `apiClient: ShopScriptApiClient` - Access API client
- `authApi: AuthApi` - Access auth API
- `productApi: ProductApi` - Access product API
- `cartApi: CartApi` - Access cart API
- `orderApi: OrderApi` - Access order API
- `checkoutApi: CheckoutApi` - Access checkout API
- `authService: AuthService` - Access auth service
- `cartService: CartService` - Access cart service

## Authentication

### AuthService

High-level authentication service with state management.

#### Properties

- `currentCustomer: Customer?` - Current authenticated customer
- `isAuthenticated: bool` - Authentication status
- `isLoading: bool` - Loading state
- `error: String?` - Last error message

#### Methods

##### login()

```dart
final response = await authService.login(
  email: 'customer@example.com',
  password: 'password123',
  rememberMe: true,
);
```

##### register()

```dart
final customer = await authService.register(
  email: 'new@example.com',
  password: 'password123',
  firstName: 'John',
  lastName: 'Doe',
  phone: '+1234567890',
);
```

##### getCurrentCustomer()

```dart
final customer = await authService.getCurrentCustomer();
```

##### updateCustomer()

```dart
final updatedCustomer = await authService.updateCustomer(
  email: 'newemail@example.com',
  firstName: 'John',
  lastName: 'Smith',
);
```

##### changePassword()

```dart
await authService.changePassword(
  currentPassword: 'oldpass',
  newPassword: 'newpass123',
);
```

##### resetPassword()

```dart
await authService.resetPassword(
  email: 'customer@example.com',
);
```

##### logout()

```dart
await authService.logout();
```

## Products

### ProductApi

Product catalog operations.

#### getProducts()

Get products with pagination and filters.

```dart
final response = await productApi.getProducts(
  page: 1,
  pageSize: 20,
  filters: ProductFilterParams(
    searchQuery: 'tea',
    categoryId: 5,
    minPrice: 10.0,
    maxPrice: 100.0,
    inStock: true,
    featured: true,
    sortBy: 'price',
    sortOrder: 'asc',
  ),
);

print('Total: ${response.total}');
for (var product in response.products) {
  print('${product.name} - \$${product.price}');
}
```

#### getProduct()

Get single product by ID.

```dart
final product = await productApi.getProduct(123);
```

#### searchProducts()

Search products by query.

```dart
final response = await productApi.searchProducts(
  query: 'herbal tea',
  page: 1,
  pageSize: 20,
);
```

#### getProductsByCategory()

Get products in a specific category.

```dart
final response = await productApi.getProductsByCategory(
  categoryId: 5,
  page: 1,
  pageSize: 20,
);
```

#### getCategories()

Get all categories.

```dart
final categories = await productApi.getCategories();
```

#### getCategory()

Get single category by ID.

```dart
final category = await productApi.getCategory(5);
```

#### getProductReviews()

Get reviews for a product.

```dart
final reviews = await productApi.getProductReviews(
  productId: 123,
  page: 1,
  pageSize: 10,
);
```

#### addProductReview()

Add a review for a product.

```dart
final review = await productApi.addProductReview(
  productId: 123,
  rating: 5,
  title: 'Great product!',
  text: 'I love this herbal tea.',
);
```

#### getRelatedProducts()

Get related products.

```dart
final related = await productApi.getRelatedProducts(123);
```

#### getFeaturedProducts()

Get featured products.

```dart
final featured = await productApi.getFeaturedProducts(
  page: 1,
  pageSize: 10,
);
```

## Cart

### CartService

Shopping cart management with state management.

#### Properties

- `cart: Cart?` - Current cart
- `itemCount: int` - Number of items in cart
- `subtotal: double` - Cart subtotal
- `total: double` - Cart total
- `isLoading: bool` - Loading state
- `error: String?` - Last error
- `isEmpty: bool` - Check if cart is empty

#### Methods

##### loadCart()

```dart
await cartService.loadCart();
```

##### addToCart()

```dart
await cartService.addToCart(
  productId: 123,
  quantity: 2,
  variantId: 'variant-1',
  options: {'size': 'large', 'color': 'blue'},
);
```

##### updateItemQuantity()

```dart
await cartService.updateItemQuantity(
  itemId: 'item-123',
  quantity: 3,
);
```

##### removeItem()

```dart
await cartService.removeItem('item-123');
```

##### clearCart()

```dart
await cartService.clearCart();
```

##### applyCoupon()

```dart
await cartService.applyCoupon('SAVE20');
```

##### removeCoupon()

```dart
await cartService.removeCoupon();
```

##### getTotals()

```dart
final totals = await cartService.getTotals();
print('Subtotal: ${totals.subtotal}');
print('Tax: ${totals.tax}');
print('Shipping: ${totals.shipping}');
print('Total: ${totals.total}');
```

##### getShippingMethods()

```dart
final methods = await cartService.getShippingMethods();
for (var method in methods) {
  print('${method.name} - \$${method.price}');
}
```

##### getPaymentMethods()

```dart
final methods = await cartService.getPaymentMethods();
for (var method in methods) {
  print('${method.name} - ${method.description}');
}
```

## Orders

### OrderApi

Order management operations.

#### getOrders()

Get customer orders.

```dart
final response = await orderApi.getOrders(
  page: 1,
  pageSize: 20,
);

for (var order in response.orders) {
  print('Order ${order.orderNumber} - ${order.status}');
}
```

#### getOrder()

Get single order by ID.

```dart
final order = await orderApi.getOrder(789);
```

#### getOrderByNumber()

Get order by order number.

```dart
final order = await orderApi.getOrderByNumber('ORD-12345');
```

#### cancelOrder()

Cancel an order.

```dart
final cancelledOrder = await orderApi.cancelOrder(
  orderId: 789,
  reason: 'Changed mind',
);
```

#### reorder()

Create new order from existing order.

```dart
final newOrderId = await orderApi.reorder(789);
```

#### trackOrder()

Get tracking information for an order.

```dart
final tracking = await orderApi.trackOrder(789);
print('Tracking number: ${tracking['tracking_number']}');
print('Status: ${tracking['status']}');
```

## Checkout

### CheckoutApi

Checkout and payment operations.

#### placeOrder()

Place an order from cart.

```dart
final response = await checkoutApi.placeOrder(
  request: CheckoutRequest(
    shippingAddress: Address(
      street: '123 Main St',
      city: 'New York',
      region: 'NY',
      postcode: '10001',
      country: 'US',
    ),
    billingAddress: Address(
      street: '123 Main St',
      city: 'New York',
      region: 'NY',
      postcode: '10001',
      country: 'US',
    ),
    shippingMethodId: 'standard',
    paymentMethodId: 'card',
    comment: 'Please deliver in the morning',
    couponCode: 'SAVE20',
  ),
);

print('Order placed: ${response.order.orderNumber}');
if (response.paymentUrl != null) {
  // Redirect to payment gateway
  print('Payment URL: ${response.paymentUrl}');
}
```

#### validateCheckout()

Validate checkout data before placing order.

```dart
final validation = await checkoutApi.validateCheckout(
  request: checkoutRequest,
);

if (validation['valid'] == true) {
  // Proceed with order
} else {
  // Show errors
  print('Validation errors: ${validation['errors']}');
}
```

#### processPayment()

Process payment for an order.

```dart
final result = await checkoutApi.processPayment(
  orderId: 789,
  paymentMethodId: 'card',
  paymentData: {
    'card_number': '4111111111111111',
    'cvv': '123',
    'expiry': '12/25',
    'name': 'John Doe',
  },
);

if (result['status'] == 'success') {
  print('Payment successful');
} else {
  print('Payment failed: ${result['error']}');
}
```

#### confirmPayment()

Confirm payment after external gateway processing.

```dart
final order = await checkoutApi.confirmPayment(
  orderId: 789,
  paymentToken: 'tok_1234567890',
);

print('Payment confirmed. Order status: ${order.status}');
```

## Exception Handling

### Exception Types

All exceptions extend `ShopScriptException` base class.

#### ShopScriptException

```dart
try {
  // API call
} on ShopScriptException catch (e) {
  print('Error: ${e.message}');
  print('Code: ${e.code}');
  print('Status: ${e.statusCode}');
}
```

#### AuthenticationException

```dart
try {
  await authService.login(email: email, password: password);
} on AuthenticationException catch (e) {
  if (e is InvalidCredentialsException) {
    print('Invalid email or password');
  } else if (e is SessionExpiredException) {
    print('Session expired. Please login again.');
  } else {
    print('Authentication error: ${e.message}');
  }
}
```

#### NetworkException

```dart
try {
  await productApi.getProducts();
} on NetworkException catch (e) {
  print('Network error: ${e.message}');
  // Show offline UI
}
```

#### ValidationException

```dart
try {
  await authService.register(...);
} on ValidationException catch (e) {
  print('Validation error: ${e.message}');
  if (e.errors != null) {
    for (var field in e.errors!.keys) {
      print('$field: ${e.errors![field]!.join(', ')}');
    }
  }
}
```

#### NotFoundException

```dart
try {
  await productApi.getProduct(999);
} on ProductNotFoundException catch (e) {
  print('Product not found');
} on OrderNotFoundException catch (e) {
  print('Order not found');
} on NotFoundException catch (e) {
  print('Resource not found: ${e.message}');
}
```

#### CartException

```dart
try {
  await cartService.addToCart(productId: 123);
} on CartException catch (e) {
  print('Cart error: ${e.message}');
}
```

#### PaymentException

```dart
try {
  await checkoutApi.processPayment(...);
} on PaymentException catch (e) {
  print('Payment error: ${e.message}');
}
```

#### CheckoutException

```dart
try {
  await checkoutApi.placeOrder(...);
} on CheckoutException catch (e) {
  print('Checkout error: ${e.message}');
}
```

### Global Error Handler

```dart
try {
  // Your code
} on ShopScriptException catch (e) {
  // Handle specific ShopScript errors
  _handleShopScriptError(e);
} catch (e, stackTrace) {
  // Handle other errors
  debugPrint('Unexpected error: $e');
  debugPrint('Stack trace: $stackTrace');
}

void _handleShopScriptError(ShopScriptException e) {
  if (e is NetworkException) {
    // Show offline message
  } else if (e is AuthenticationException) {
    // Redirect to login
  } else if (e is ValidationException) {
    // Show validation errors
  } else {
    // Show generic error message
  }
}
```

