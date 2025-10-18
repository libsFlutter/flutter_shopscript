import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_models.freezed.dart';
part 'cart_models.g.dart';

/// Shopping cart model
@freezed
class Cart with _$Cart {
  const factory Cart({
    String? id,
    required List<CartItem> items,
    required double subtotal,
    double? discount,
    double? shipping,
    double? tax,
    required double total,
    String? currency,
    String? couponCode,
    int? itemCount,
    @Default({}) Map<String, dynamic> meta,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}

/// Cart item model
@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
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
    @Default({}) Map<String, dynamic> meta,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}

/// Cart totals breakdown
@freezed
class CartTotals with _$CartTotals {
  const factory CartTotals({
    required double subtotal,
    required double discount,
    required double shipping,
    required double tax,
    required double total,
    String? currency,
    @Default([]) List<TotalSegment> segments,
  }) = _CartTotals;

  factory CartTotals.fromJson(Map<String, dynamic> json) =>
      _$CartTotalsFromJson(json);
}

/// Total segment for detailed breakdown
@freezed
class TotalSegment with _$TotalSegment {
  const factory TotalSegment({
    required String code,
    required String title,
    required double value,
  }) = _TotalSegment;

  factory TotalSegment.fromJson(Map<String, dynamic> json) =>
      _$TotalSegmentFromJson(json);
}

/// Add to cart request
@freezed
class AddToCartRequest with _$AddToCartRequest {
  const factory AddToCartRequest({
    required int productId,
    @Default(1) int quantity,
    String? variantId,
    @Default({}) Map<String, dynamic> options,
  }) = _AddToCartRequest;

  factory AddToCartRequest.fromJson(Map<String, dynamic> json) =>
      _$AddToCartRequestFromJson(json);
}

/// Update cart item request
@freezed
class UpdateCartItemRequest with _$UpdateCartItemRequest {
  const factory UpdateCartItemRequest({
    required String itemId,
    int? quantity,
    Map<String, dynamic>? options,
  }) = _UpdateCartItemRequest;

  factory UpdateCartItemRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCartItemRequestFromJson(json);
}

/// Apply coupon request
@freezed
class ApplyCouponRequest with _$ApplyCouponRequest {
  const factory ApplyCouponRequest({required String couponCode}) =
      _ApplyCouponRequest;

  factory ApplyCouponRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyCouponRequestFromJson(json);
}

/// Shipping method
@freezed
class ShippingMethod with _$ShippingMethod {
  const factory ShippingMethod({
    required String id,
    required String name,
    String? description,
    required double price,
    String? currency,
    String? estimatedDelivery,
    @Default({}) Map<String, dynamic> meta,
  }) = _ShippingMethod;

  factory ShippingMethod.fromJson(Map<String, dynamic> json) =>
      _$ShippingMethodFromJson(json);
}

/// Payment method
@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String id,
    required String name,
    String? description,
    String? logo,
    @Default(true) bool enabled,
    @Default({}) Map<String, dynamic> config,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}
