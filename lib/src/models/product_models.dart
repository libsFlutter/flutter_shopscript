import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part 'product_models.freezed.dart';
part 'product_models.g.dart';

/// ShopScript Product model
///
/// Represents a product in the ShopScript catalog with all its attributes,
/// pricing, stock information, and relationships.
@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    String? summary,
    String? description,
    required double price,
    double? comparePrice,
    String? currency,
    String? sku,
    @Default([]) List<String> images,
    String? mainImage,
    int? rating,
    int? reviewCount,
    @Default(0) int stockQuantity,
    @Default(true) bool inStock,
    int? categoryId,
    String? categoryName,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> features,
    @Default({}) Map<String, dynamic> params,
    DateTime? createdAt,
    DateTime? modifiedAt,
    String? url,
    @Default(false) bool featured,
    @Default([]) List<ProductVariant> variants,
    @Default([]) List<int> relatedProductIds,
    @Default({}) Map<String, dynamic> meta,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

/// Product variant (for configurable products)
@freezed
class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required int id,
    required String name,
    required double price,
    String? sku,
    @Default(0) int stockQuantity,
    @Default({}) Map<String, dynamic> options,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);
}

/// Product list response with pagination
@freezed
class ProductListResponse with _$ProductListResponse {
  const factory ProductListResponse({
    required List<Product> products,
    required int total,
    required int page,
    required int pageSize,
    int? totalPages,
  }) = _ProductListResponse;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseFromJson(json);
}

/// Product category
@freezed
class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    required int id,
    required String name,
    String? description,
    String? image,
    int? parentId,
    int? count,
    String? url,
    @Default([]) List<ProductCategory> subcategories,
    @Default({}) Map<String, dynamic> meta,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
}

/// Product review
@freezed
class ProductReview with _$ProductReview {
  const factory ProductReview({
    required int id,
    required int productId,
    required int rating,
    String? title,
    String? text,
    String? authorName,
    String? authorEmail,
    DateTime? createdAt,
    @Default(true) bool approved,
  }) = _ProductReview;

  factory ProductReview.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewFromJson(json);
}

/// Product filter parameters
class ProductFilterParams extends Equatable {
  final String? searchQuery;
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final List<String>? tags;
  final bool? inStock;
  final bool? featured;
  final String? sortBy;
  final String? sortOrder;

  const ProductFilterParams({
    this.searchQuery,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.tags,
    this.inStock,
    this.featured,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [
    searchQuery,
    categoryId,
    minPrice,
    maxPrice,
    tags,
    inStock,
    featured,
    sortBy,
    sortOrder,
  ];

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (searchQuery != null) json['query'] = searchQuery;
    if (categoryId != null) json['category_id'] = categoryId;
    if (minPrice != null) json['price_min'] = minPrice;
    if (maxPrice != null) json['price_max'] = maxPrice;
    if (tags != null && tags!.isNotEmpty) json['tags'] = tags!.join(',');
    if (inStock != null) json['in_stock'] = inStock! ? 1 : 0;
    if (featured != null) json['featured'] = featured! ? 1 : 0;
    if (sortBy != null) json['sort'] = sortBy;
    if (sortOrder != null) json['order'] = sortOrder;
    return json;
  }
}
