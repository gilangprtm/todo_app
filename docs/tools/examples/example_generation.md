# Contoh Penggunaan Generator

Berikut adalah contoh penggunaan Generator untuk membuat komponen untuk fitur "Product".

## 1. Membuat Model

```bash
flutter pub run generator:create model --name=product --fields="id:int,name:String,price:double,description:String?,imageUrl:String?"
```

Output yang dihasilkan:

```dart
// lib/data/models/product_model.dart
class ProductModel {
  final int id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image_url': imageUrl,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
```

## 2. Membuat Repository

```bash
flutter pub run generator:create repository --name=product --model=ProductModel --endpoints="getProducts:GET:/products,getProductById:GET:/products/{id}"
```

Output yang dihasilkan:

```dart
// lib/data/datasource/network/repository/product_repository.dart
class ProductRepository extends BaseRepository {
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('/products');
    return (response.data as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await dio.get('/products/$id');
    return ProductModel.fromJson(response.data);
  }
}
```

## 3. Membuat Service

```bash
flutter pub run generator:create service --name=product --model=ProductModel --repository=ProductRepository
```

Output yang dihasilkan:

```dart
// lib/data/datasource/network/service/product_service.dart
class ProductService extends BaseService {
  final ProductRepository _repository = ProductRepository();

  Future<List<ProductModel>> getProducts({bool forceRefresh = false}) {
    final cacheKey = 'products_list';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24, // 1 day
      forceRefresh: forceRefresh,
      operationName: 'ProductService.getProducts',
      fetchFunction: () async {
        return await _repository.getProducts();
      },
      tag: 'ProductService',
    );
  }

  Future<ProductModel> getProductById(int id, {bool forceRefresh = false}) {
    final cacheKey = 'product_$id';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24, // 1 day
      forceRefresh: forceRefresh,
      operationName: 'ProductService.getProductById',
      fetchFunction: () async {
        return await _repository.getProductById(id);
      },
      tag: 'ProductService',
    );
  }

  Future<void> clearCache() async {
    final cacheService = CacheService();
    await cacheService.clearCacheByTag('ProductService');
  }
}
```

## 4. Membuat State

```bash
flutter pub run generator:create state --name=product_list --properties="products:List<ProductModel>=const [],currentPage:int=1,hasMore:bool=true,searchQuery:String=''"
```

Output yang dihasilkan:

```dart
// lib/presentation/providers/product/product_list/product_list_state.dart
class ProductListState extends BaseState {
  final List<ProductModel> products;
  final int currentPage;
  final bool hasMore;
  final String searchQuery;

  const ProductListState({
    this.products = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.searchQuery = '',
    super.isLoading = false,
    super.error,
    super.stackTrace,
  });

  @override
  ProductListState copyWith({
    List<ProductModel>? products,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
    bool? isLoading,
    String? error,
    StackTrace? stackTrace,
    bool clearError = false,
  }) {
    return ProductListState(
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
    );
  }
}
```

## 5. Membuat Notifier

```bash
flutter pub run generator:create notifier --name=product_list --state=ProductListState --service=ProductService --methods="loadProducts,searchProducts"
```

Output yang dihasilkan:

```dart
// lib/presentation/providers/product/product_list/product_list_notifier.dart
class ProductListNotifier extends BaseStateNotifier<ProductListState> {
  final ProductService _productService;

  ProductListNotifier(super.initialState, super.ref, this._productService);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts({bool refresh = false}) async {
    await runAsync('loadProducts', () async {
      if (refresh) {
        state = state.copyWith(
          products: [],
          currentPage: 1,
          hasMore: true,
          clearError: true,
        );
      }

      if (!state.hasMore) return;

      final offset = (state.currentPage - 1) * 20;
      final products = await _productService.getProducts(
        forceRefresh: refresh,
      );

      state = state.copyWith(
        products: [...state.products, ...products],
        currentPage: state.currentPage + 1,
        hasMore: products.isNotEmpty && products.length >= 20,
      );
    });
  }

  Future<void> searchProducts(String query) async {
    await runAsync('searchProducts', () async {
      state = state.copyWith(
        searchQuery: query,
        products: [],
        currentPage: 1,
        hasMore: true,
      );

      if (query.isEmpty) {
        await loadProducts(refresh: true);
        return;
      }

      final products = state.products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
               (product.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();

      state = state.copyWith(
        products: products,
        hasMore: false,
      );
    });
  }

  Future<void> refresh() async {
    await loadProducts(refresh: true);
  }

  Future<void> clearCache() async {
    await _productService.clearCache();
    await loadProducts(refresh: true);
  }
}
```

## 6. Membuat Provider

```bash
flutter pub run generator:create provider --name=product_list --notifier=ProductListNotifier --state=ProductListState --dependencies="productService:ProductService"
```

Output yang dihasilkan:

```dart
// lib/presentation/providers/product/product_list/product_list_provider.dart
final productListProvider = StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductListNotifier(
    const ProductListState(),
    ref,
    productService,
  );
});

// Update file: lib/core/di/service_providers.dart
// (Berikut adalah bagian yang ditambahkan ke file tersebut)
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});
```

## 7. Membuat Fitur Lengkap

```bash
flutter pub run generator:create feature --name=product --model="id:int,name:String,price:double,description:String?,imageUrl:String?" --endpoints="list:GET:/products,detail:GET:/products/{id}" --states="list:products:List<ProductModel>,detail:product:ProductModel"
```

Output yang dihasilkan:
Semua file yang telah disebutkan di atas akan dibuat sekaligus, dengan tambahan:

```dart
// lib/presentation/pages/product/product_list/product_list_page.dart dan
// lib/presentation/pages/product/product_detail/product_detail_page.dart

// Template dasar halaman yang bisa dikustomisasi lebih lanjut.
```

## Kustomisasi Config

Berikut contoh konfigurasi kustom untuk generator:

```yaml
# generator_config.yaml
output_paths:
  models: lib/data/models
  repositories: lib/data/network/repositories
  services: lib/data/services
  states: lib/presentation/providers/{feature}/{subfeature}
  notifiers: lib/presentation/providers/{feature}/{subfeature}
  providers: lib/presentation/providers/{feature}/{subfeature}

templates:
  model: lib/core/generator/templates/custom_model_template.dart
  repository: lib/core/generator/templates/repository_template.dart
  service: lib/core/generator/templates/custom_service_template.dart
  state: lib/core/generator/templates/state_template.dart
  notifier: lib/core/generator/templates/notifier_template.dart
  provider: lib/core/generator/templates/provider_template.dart

default_values:
  cache_ttl_minutes: 120 # 2 hours
  pagination_size: 25
  imports:
    - "package:flutter/material.dart"
    - "package:flutter_riverpod/flutter_riverpod.dart"
    - "package:fokedex/core/utils/logging.dart"
```
