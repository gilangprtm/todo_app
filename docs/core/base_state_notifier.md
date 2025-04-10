# BaseStateNotifier dan BaseState

## Pengenalan

`BaseStateNotifier` dan `BaseState` adalah kelas dasar yang menyediakan struktur dan fungsionalitas umum untuk manajemen state dalam aplikasi. Kelas-kelas ini dirancang untuk bekerja dengan Riverpod sebagai solusi manajemen state.

## BaseState

`BaseState` adalah kelas abstrak yang berfungsi sebagai model untuk semua kelas state dalam aplikasi.

```dart
abstract class BaseState {
  final bool isLoading;
  final String? error;
  final StackTrace? stackTrace;

  const BaseState({
    this.isLoading = false,
    this.error,
    this.stackTrace,
  });

  BaseState copyWith({
    bool? isLoading,
    String? error,
    StackTrace? stackTrace,
    bool clearError = false,
  });
}
```

### Properti

- `isLoading`: Menunjukkan apakah state sedang dalam proses loading.
- `error`: Pesan error jika terjadi kesalahan.
- `stackTrace`: Stack trace dari error yang terjadi.

### Metode

- `copyWith()`: Metode abstrak yang harus diimplementasikan oleh subclass untuk membuat salinan state dengan nilai yang diperbarui.

## Contoh Implementasi BaseState

```dart
class ProductState extends BaseState {
  final List<ProductModel> products;

  const ProductState({
    this.products = const [],
    super.isLoading = false,
    super.error,
    super.stackTrace,
  });

  @override
  ProductState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    String? error,
    StackTrace? stackTrace,
    bool clearError = false,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
    );
  }
}
```

## BaseStateNotifier

`BaseStateNotifier` adalah kelas generic yang memperluas `StateNotifier` dari Riverpod untuk menyediakan fungsionalitas umum.

```dart
class BaseStateNotifier<T extends BaseState> extends StateNotifier<T> {
  final Ref ref;

  BaseStateNotifier(T initialState, this.ref) : super(initialState) {
    _init();
  }

  void _init() async {
    await Future.microtask(() => onInit());
  }

  void onInit() {
    // Override this method to perform initialization
  }

  void onDispose() {
    // Override this method to perform cleanup
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  // State management methods

  // Helper methods for operations
}
```

### Properti

- `ref`: Referensi ke objek `Ref` dari Riverpod, memungkinkan akses ke provider lain.

### Metode Siklus Hidup

- `_init()`: Metode internal yang memanggil `onInit()` pada microtask berikutnya.
- `onInit()`: Metode yang dapat di-override untuk melakukan inisialisasi.
- `onDispose()`: Metode yang dapat di-override untuk melakukan pembersihan.

### Metode Manajemen State

```dart
// Set loading state
void setLoading() {
  state = state.copyWith(isLoading: true, clearError: true) as T;
}

// Clear loading state
void clearLoading() {
  state = state.copyWith(isLoading: false) as T;
}

// Set error state
void setError(String message, [StackTrace? stackTrace]) {
  state = state.copyWith(
    isLoading: false,
    error: message,
    stackTrace: stackTrace,
  ) as T;

  logError('Error in ${T.toString()}', message, stackTrace);
}

// Clear error state
void clearError() {
  state = state.copyWith(clearError: true) as T;
}
```

### Metode Helper untuk Operasi

```dart
// Run a synchronous operation with error handling
T run(String operationName, T Function() operation) {
  try {
    return operation();
  } catch (e, stackTrace) {
    setError('Error in $operationName: ${e.toString()}', stackTrace);
    logError('Error in $operationName', e, stackTrace);
    rethrow;
  }
}

// Run an asynchronous operation with error handling
Future<void> runAsync(
  String operationName,
  Future<void> Function() operation,
) async {
  try {
    setLoading();
    await operation();
  } catch (e, stackTrace) {
    setError('Error in $operationName: ${e.toString()}', stackTrace);
    logError('Error in $operationName', e, stackTrace);
    rethrow;
  } finally {
    clearLoading();
  }
}
```

## Contoh Implementasi BaseStateNotifier

```dart
class ProductNotifier extends BaseStateNotifier<ProductState> {
  final ProductService _productService;

  ProductNotifier(super.initialState, super.ref, this._productService);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    await runAsync('loadProducts', () async {
      final products = await _productService.getProducts();
      state = state.copyWith(products: products);
    });
  }

  Future<void> refreshProducts() async {
    await runAsync('refreshProducts', () async {
      final products = await _productService.getProducts(forceRefresh: true);
      state = state.copyWith(products: products);
    });
  }
}
```

## Integrasi dengan Provider

```dart
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductNotifier(
    const ProductState(),
    ref,
    productService,
  );
});
```

## Penggunaan di UI

```dart
class ProductListPage extends ConsumerWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Optimize rebuilds with select
    final products = ref.watch(
      productProvider.select((state) => state.products)
    );

    final isLoading = ref.watch(
      productProvider.select((state) => state.isLoading)
    );

    final error = ref.watch(
      productProvider.select((state) => state.error)
    );

    // Error handling
    if (error != null) {
      return ErrorView(
        error: error,
        onRetry: () => ref.read(productProvider.notifier).refreshProducts(),
      );
    }

    // Loading state
    if (isLoading && products.isEmpty) {
      return const LoadingView();
    }

    // Empty state
    if (products.isEmpty) {
      return EmptyView(
        message: 'No products found',
        onRefresh: () => ref.read(productProvider.notifier).refreshProducts(),
      );
    }

    // Content
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => ProductItem(product: products[index]),
    );
  }
}
```

## Keuntungan Menggunakan BaseStateNotifier dan BaseState

1. **Konsistensi**: Memastikan semua state memiliki struktur dan behavior yang konsisten.

2. **Pengurangan Kode Boilerplate**: Menyediakan metode umum untuk manajemen state, mengurangi duplikasi kode.

3. **Penanganan Error Terpusat**: Mekanisme standar untuk menangani dan menampilkan error.

4. **Manajemen Loading State**: Mekanisme standar untuk menangani loading state.

5. **Lifecycle Hooks**: Menyediakan hooks (`onInit` dan `onDispose`) untuk melakukan inisialisasi dan pembersihan.

6. **Testing**: Memudahkan unit testing karena struktur yang konsisten.

## Pertimbangan untuk Pengembangan

1. **Generic Type Safety**: Pastikan selalu menerapkan state yang benar dengan generic type untuk mencegah error saat runtime.

2. **Memory Management**: Gunakan `onDispose` untuk membersihkan sumber daya yang tidak lagi diperlukan.

3. **State Immutability**: Pastikan state selalu immutable dan diperbarui melalui metode `copyWith`.

4. **Error Logging**: Implementasikan sistem logging untuk error yang komprehensif.

5. **Unit Testing**: Buat unit test untuk semua notifier untuk memastikan behavior yang diharapkan.

## Contoh Unit Test

```dart
void main() {
  test('ProductNotifier - loadProducts', () async {
    // Setup
    final mockProductService = MockProductService();
    final container = ProviderContainer(
      overrides: [
        productServiceProvider.overrideWithValue(mockProductService),
      ],
    );

    // Expectations
    when(mockProductService.getProducts()).thenAnswer(
      (_) async => [ProductModel(id: 1, name: 'Test Product')],
    );

    // Initial state should have empty products and not be loading
    expect(container.read(productProvider).products, isEmpty);
    expect(container.read(productProvider).isLoading, isFalse);

    // Wait for onInit to complete (loadProducts is called in onInit)
    await Future.delayed(Duration.zero);

    // State should have products and not be loading
    expect(container.read(productProvider).products, hasLength(1));
    expect(container.read(productProvider).isLoading, isFalse);

    // Verify
    verify(mockProductService.getProducts()).called(1);
  });
}
```
