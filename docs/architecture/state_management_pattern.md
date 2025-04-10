# Pola State Management dengan Riverpod

## Konsep Utama

Aplikasi ini menggunakan Riverpod sebagai solusi state management dengan pendekatan yang terstruktur dan dapat diskalakan. Implementasi Riverpod dibuat dengan pola dasar berikut:

```
State ──▶ StateNotifier ──▶ Provider ──▶ UI (Consumer)
```

Pola ini memisahkan:

- **State**: Data dan kondisi aplikasi
- **StateNotifier**: Logika untuk memanipulasi state
- **Provider**: Titik akses state ke UI
- **Consumer**: Komponen UI yang membaca dan merespon state

## Struktur Dasar

### 1. State

State adalah kelas immutable yang memperluas `BaseState` dan berisi data untuk fitur tertentu.

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
  ProductListState copyWith({...});
}
```

### 2. StateNotifier

StateNotifier adalah kelas yang memperluas `BaseStateNotifier<T>` dan berisi logika bisnis.

```dart
class ProductListNotifier extends BaseStateNotifier<ProductListState> {
  final ProductService _productService;

  ProductListNotifier(super.initialState, super.ref, this._productService);

  Future<void> loadProducts() async {
    await runAsync('loadProducts', () async {
      final products = await _productService.getProducts();
      state = state.copyWith(products: products);
    });
  }
}
```

### 3. Provider

Provider adalah instance Riverpod yang mengekspos state dan notifier ke UI.

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

### 4. Consumer

Consumer adalah widget yang menggunakan provider untuk mengakses state.

```dart
class ProductListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(
      productListProvider.select((state) => state.products)
    );
    // ...
  }
}
```

## Pola Optimasi (Select)

Untuk optimasi performa, menggunakan `select` untuk hanya mengambil bagian state yang dibutuhkan:

```dart
// TIDAK DISARANKAN: Seluruh state akan menyebabkan rebuild
final state = ref.watch(productListProvider);

// DISARANKAN: Hanya memicu rebuild saat products berubah
final products = ref.watch(
  productListProvider.select((state) => state.products)
);
```

## Interaksi dengan Caching

State management terintegrasi dengan sistem caching:

```dart
// Di Service
Future<List<Product>> getProducts({bool forceRefresh = false}) {
  return cachedOperationAsync(
    cacheKey: 'products_list',
    forceRefresh: forceRefresh,
    // ...
  );
}

// Di Notifier
Future<void> refresh() async {
  await runAsync('refresh', () async {
    final products = await _productService.getProducts(forceRefresh: true);
    state = state.copyWith(products: products);
  });
}
```

## Penanganan Error

Error handling terintegrasi dalam BaseStateNotifier:

```dart
// Di Notifier (otomatis)
await runAsync('operation', () async {
  // Error akan otomatis di-handle
});

// Di UI
final error = ref.watch(
  productListProvider.select((state) => state.error)
);

if (error != null) {
  return ErrorWidget(error: error);
}
```

## Pemisahan Concerns

Pola ini menekankan pemisahan concerns yang baik:

1. **UI**: Hanya menangani tampilan dan interaksi pengguna
2. **Notifier**: Menangani logika bisnis dan manipulasi state
3. **Service**: Menangani operasi data dan caching
4. **Repository**: Menangani akses data mentah

## Family Provider

Untuk provider yang memerlukan parameter, gunakan Family:

```dart
final productDetailProvider = StateNotifierProvider.family<ProductDetailNotifier, ProductDetailState, int>(
  (ref, id) {
    final productService = ref.watch(productServiceProvider);
    return ProductDetailNotifier(
      const ProductDetailState(),
      ref,
      productService,
      id,
    );
  },
);

// Penggunaan
final state = ref.watch(productDetailProvider(123));
```

## Keuntungan Pola Ini

1. **Terstruktur**: Memiliki struktur yang jelas dan konsisten
2. **Testable**: Setiap komponen dapat diuji secara terpisah
3. **Maintainable**: Pemisahan yang jelas memudahkan maintenance
4. **Scalable**: Dapat diskalakan untuk aplikasi besar
5. **Performant**: Optimasi dengan `select` dan caching
6. **Type-safe**: Memanfaatkan typesafety Dart
