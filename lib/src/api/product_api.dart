import '../models/product_models.dart';
import '../exceptions/shopscript_exception.dart';
import 'shopscript_api_client.dart';

/// Product API for ShopScript
///
/// Handles product catalog operations including listing, searching, and categories
class ProductApi {
  final ShopScriptApiClient _client;

  ProductApi(this._client);

  /// Get products with pagination and filters
  ///
  /// Returns [ProductListResponse] with products and pagination info
  Future<ProductListResponse> getProducts({
    int page = 1,
    int pageSize = 20,
    ProductFilterParams? filters,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': pageSize,
        ...?filters?.toJson(),
      };

      final response = await _client.get(
        '/api/products',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        return ProductListResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ShopScriptException('Failed to fetch products');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch products: $e');
    }
  }

  /// Get single product by ID
  ///
  /// Returns [Product] object
  Future<Product> getProduct(int productId) async {
    try {
      final response = await _client.get('/api/products/$productId');

      if (response.statusCode == 200 && response.data != null) {
        return Product.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw ProductNotFoundException(productId.toString());
      } else {
        throw ShopScriptException('Failed to fetch product');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch product: $e');
    }
  }

  /// Search products by query
  ///
  /// Returns [ProductListResponse] with search results
  Future<ProductListResponse> searchProducts({
    required String query,
    int page = 1,
    int pageSize = 20,
    ProductFilterParams? filters,
  }) async {
    try {
      final queryParams = {
        'query': query,
        'page': page,
        'limit': pageSize,
        ...?filters?.toJson(),
      };

      final response = await _client.get(
        '/api/products/search',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        return ProductListResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ShopScriptException('Failed to search products');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to search products: $e');
    }
  }

  /// Get products by category
  ///
  /// Returns [ProductListResponse] with products in category
  Future<ProductListResponse> getProductsByCategory({
    required int categoryId,
    int page = 1,
    int pageSize = 20,
    ProductFilterParams? filters,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': pageSize,
        ...?filters?.toJson(),
      };

      final response = await _client.get(
        '/api/categories/$categoryId/products',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        return ProductListResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ShopScriptException('Failed to fetch category products');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch category products: $e');
    }
  }

  /// Get all categories
  ///
  /// Returns list of [ProductCategory]
  Future<List<ProductCategory>> getCategories() async {
    try {
      final response = await _client.get('/api/categories');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final categories =
            data['data'] as List? ?? data['categories'] as List? ?? [];
        return categories
            .map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw ShopScriptException('Failed to fetch categories');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch categories: $e');
    }
  }

  /// Get category by ID
  ///
  /// Returns [ProductCategory] object
  Future<ProductCategory> getCategory(int categoryId) async {
    try {
      final response = await _client.get('/api/categories/$categoryId');

      if (response.statusCode == 200 && response.data != null) {
        return ProductCategory.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException('Category not found');
      } else {
        throw ShopScriptException('Failed to fetch category');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch category: $e');
    }
  }

  /// Get product reviews
  ///
  /// Returns list of [ProductReview]
  Future<List<ProductReview>> getProductReviews({
    required int productId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _client.get(
        '/api/products/$productId/reviews',
        queryParameters: {'page': page, 'limit': pageSize},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final reviews = data['data'] as List? ?? data['reviews'] as List? ?? [];
        return reviews
            .map((e) => ProductReview.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw ShopScriptException('Failed to fetch product reviews');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch product reviews: $e');
    }
  }

  /// Add product review
  ///
  /// Returns created [ProductReview]
  Future<ProductReview> addProductReview({
    required int productId,
    required int rating,
    String? title,
    String? text,
  }) async {
    try {
      final response = await _client.post(
        '/api/products/$productId/reviews',
        data: {
          'rating': rating,
          if (title != null) 'title': title,
          if (text != null) 'text': text,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ProductReview.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ShopScriptException('Failed to add review');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to add review: $e');
    }
  }

  /// Get related products
  ///
  /// Returns list of [Product] that are related to the given product
  Future<List<Product>> getRelatedProducts(int productId) async {
    try {
      final response = await _client.get('/api/products/$productId/related');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final products =
            data['data'] as List? ?? data['products'] as List? ?? [];
        return products
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw ShopScriptException('Failed to fetch related products');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch related products: $e');
    }
  }

  /// Get featured products
  ///
  /// Returns list of [Product] marked as featured
  Future<List<Product>> getFeaturedProducts({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _client.get(
        '/api/products/featured',
        queryParameters: {'page': page, 'limit': pageSize},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final products =
            data['data'] as List? ?? data['products'] as List? ?? [];
        return products
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw ShopScriptException('Failed to fetch featured products');
      }
    } catch (e) {
      if (e is ShopScriptException) rethrow;
      throw ShopScriptException('Failed to fetch featured products: $e');
    }
  }
}
