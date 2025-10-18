import 'package:freezed_annotation/freezed_annotation.dart';
import 'customer_models.dart';
import 'cart_models.dart';

part 'order_models.freezed.dart';
part 'order_models.g.dart';

/// Order model
@freezed
class Order with _$Order {
  const factory Order({
    required int id,
    required String orderNumber,
    required OrderStatus status,
    required List<OrderItem> items,
    required double subtotal,
    double? discount,
    required double shipping,
    required double tax,
    required double total,
    String? currency,
    required Address shippingAddress,
    required Address billingAddress,
    String? shippingMethod,
    String? paymentMethod,
    String? couponCode,
    String? comment,
    DateTime? createdAt,
    DateTime? modifiedAt,
    String? trackingNumber,
    String? trackingUrl,
    @Default({}) Map<String, dynamic> meta,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

/// Order item
@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required int id,
    required int productId,
    required String productName,
    String? productImage,
    String? sku,
    required double price,
    required int quantity,
    double? discount,
    required double total,
    String? variantId,
    @Default({}) Map<String, dynamic> options,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

/// Order status enum
enum OrderStatus {
  @JsonValue('new')
  newOrder,
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('shipped')
  shipped,
  @JsonValue('delivered')
  delivered,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('refunded')
  refunded,
}

/// Order list response
@freezed
class OrderListResponse with _$OrderListResponse {
  const factory OrderListResponse({
    required List<Order> orders,
    required int total,
    required int page,
    required int pageSize,
  }) = _OrderListResponse;

  factory OrderListResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderListResponseFromJson(json);
}

/// Checkout request
@freezed
class CheckoutRequest with _$CheckoutRequest {
  const factory CheckoutRequest({
    required Address shippingAddress,
    required Address billingAddress,
    required String shippingMethodId,
    required String paymentMethodId,
    String? comment,
    String? couponCode,
    @Default({}) Map<String, dynamic> paymentData,
  }) = _CheckoutRequest;

  factory CheckoutRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckoutRequestFromJson(json);
}

/// Checkout response
@freezed
class CheckoutResponse with _$CheckoutResponse {
  const factory CheckoutResponse({
    required Order order,
    String? paymentUrl,
    String? paymentToken,
    @Default({}) Map<String, dynamic> meta,
  }) = _CheckoutResponse;

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponseFromJson(json);
}

/// Order status update
@freezed
class OrderStatusUpdate with _$OrderStatusUpdate {
  const factory OrderStatusUpdate({
    required OrderStatus status,
    String? comment,
  }) = _OrderStatusUpdate;

  factory OrderStatusUpdate.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusUpdateFromJson(json);
}
