# Alur Pengembangan Fitur

## Langkah-langkah Pengembangan Fitur

Pengembangan fitur baru mengikuti alur berikut:

### 1. Persiapan Lapisan Data

#### a. Buat Model

File lokasi: `lib/data/models/*_model.dart`

```dart
class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }
}
```

#### b. Buat Repository

File lokasi: `lib/data/datasource/network/repository/*_repository.dart`

```dart
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

#### c. Buat Service

File lokasi: `lib/data/datasource/network/service/*_service.dart`

```dart
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
      fromJson: (json) => ProductModel.fromJson(json),
      tag: 'ProductService',
    );
  }
}
```

### 2. Persiapan State Management

#### a. Buat State

File lokasi: `lib/presentation/providers/product/product_list/product_list_state.dart`

```dart
class ProductListState extends BaseState {
  final List<ProductModel> products;
  final bool hasMore;
  final int currentPage;

  const ProductListState({
    this.products = const [],
    this.hasMore = true,
    this.currentPage = 1,
    super.isLoading = false,
    super.error,
    super.stackTrace,
  });

  @override
  ProductListState copyWith({
    List<ProductModel>? products,
    bool? hasMore,
    int? currentPage,
    bool? isLoading,
    String? error,
    StackTrace? stackTrace,
    bool clearError = false,
  }) {
    return ProductListState(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
    );
  }
}
```

#### b. Buat Notifier

File lokasi: `lib/presentation/providers/product/product_list/product_list_notifier.dart`

```dart
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

      final products = await _productService.getProducts(
        forceRefresh: refresh,
      );

      state = state.copyWith(
        products: [...state.products, ...products],
        currentPage: state.currentPage + 1,
        hasMore: products.isNotEmpty && products.length >= 20, // Assuming page size of 20
      );
    });
  }

  Future<void> refresh() async {
    await loadProducts(refresh: true);
  }
}
```

#### c. Buat Provider

File lokasi: `lib/presentation/providers/product/product_list/product_list_provider.dart`

```dart
final productListProvider = StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductListNotifier(
    const ProductListState(),
    ref,
    productService,
  );
});
```

### 3. Persiapan Dependency Injection

Update file: `lib/core/di/service_providers.dart`

```dart
// Tambahkan provider service baru
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});
```

### 4. Persiapan Routing

Update file: `lib/presentation/routes/app_routes.dart`

```dart
class AppRoutes {
  // Routes yang sudah ada

  // Tambahkan route baru
  static const String productList = '/products';
  static const String productDetail = '/products/detail';
}
```

Update file: `lib/presentation/routes/app_routes_provider.dart`

```dart
class AppRoutesProvider {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Routes yang sudah ada

      // Tambahkan route baru
      AppRoutes.productList: (context) => const ProductListPage(),
      AppRoutes.productDetail: (context) => const ProductDetailPage(),
    };
  }
}
```

### 5. Implementasi UI

#### a. Buat Page

File lokasi: `lib/presentation/pages/product/product_list/product_list_page.dart`

```dart
class ProductListPage extends ConsumerWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Optimize rebuilds with select
    final products = ref.watch(
      productListProvider.select((state) => state.products)
    );

    final isLoading = ref.watch(
      productListProvider.select((state) => state.isLoading)
    );

    final error = ref.watch(
      productListProvider.select((state) => state.error)
    );

    final notifier = ref.read(productListProvider.notifier);

    // Error handling
    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: notifier.refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Loading state
    if (isLoading && products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Empty state
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No products found'),
            ElevatedButton(
              onPressed: notifier.refresh,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    // Content
    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductListItem(
            product: product,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.productDetail,
              arguments: product.id,
            ),
          );
        },
      ),
    );
  }
}
```

#### b. Buat Widget Spesifik

File lokasi: `lib/presentation/pages/product/product_list/widgets/product_list_item.dart`

```dart
class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductListItem({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: Text('\$${product.price.toStringAsFixed(2)}'),
        onTap: onTap,
      ),
    );
  }
}
```

## Checklist Pengembangan Fitur

Untuk memastikan fitur lengkap, gunakan checklist berikut:

- [ ] Model

  - [ ] Properties
  - [ ] fromJson/toJson
  - [ ] Unit tests

- [ ] Repository

  - [ ] API methods
  - [ ] Error handling
  - [ ] Unit tests

- [ ] Service

  - [ ] Caching implementation
  - [ ] Business logic
  - [ ] Unit tests

- [ ] State

  - [ ] Required properties
  - [ ] copyWith method
  - [ ] Unit tests

- [ ] Notifier

  - [ ] Methods for data manipulation
  - [ ] Error handling
  - [ ] Unit tests

- [ ] Provider

  - [ ] Provider registration
  - [ ] Dependencies

- [ ] UI

  - [ ] Page implementation
  - [ ] Loading state
  - [ ] Error state
  - [ ] Empty state
  - [ ] Performance optimization
  - [ ] Widget tests

- [ ] Routing
  - [ ] Route constants
  - [ ] Route registration

## Flow Diagram

Alur pengembangan fitur secara visual:

```
┌─────────────┐
│    START    │
└──────┬──────┘
       │
       ▼
┌──────────────┐
│  Create      │
│  Model       │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Create      │
│  Repository  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Create      │
│  Service     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Create      │
│  State       │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Create      │
│  Notifier    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Create      │
│  Provider    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Update DI &  │
│  Routes      │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Create UI   │
│  Components  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│    DONE     │
└──────────────┘
```
