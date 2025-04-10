# Contoh Penggunaan Riverpod

Folder ini berisi contoh implementasi Riverpod untuk beberapa kasus penggunaan umum dalam aplikasi. Contoh-contoh ini dirancang untuk menunjukkan pola dan praktik terbaik dalam mengimplementasikan manajemen state menggunakan Riverpod.

## Struktur

Folder ini berisi contoh-contoh berikut:

1. **simple_counter**: Contoh dasar penggunaan StateNotifier dan StateNotifierProvider
2. **api_integration**: Contoh penggunaan Riverpod dengan integrasi API
3. **pagination**: Contoh implementasi pagination dengan Riverpod
4. **form_handling**: Contoh penanganan form dengan Riverpod
5. **dependency_injection**: Contoh injeksi dependensi menggunakan Riverpod
6. **caching**: Contoh implementasi caching dengan Riverpod

## Cara Menggunakan Contoh

Setiap subfolder berisi contoh mandiri dengan struktur yang sesuai dengan pola arsitektur yang telah didokumentasikan. Untuk menggunakan contoh:

1. Baca dokumentasi di README.md di setiap folder contoh
2. Periksa file-file yang disediakan untuk melihat implementasi
3. Gunakan sebagai referensi saat mengimplementasikan fitur serupa

## Contoh-contoh

### 1. Simple Counter

Contoh dasar menunjukkan penggunaan StateNotifier dan StateNotifierProvider untuk membuat counter yang dapat ditambah dan dikurangi.

**Komponen**:

- `CounterState`: State sederhana dengan nilai counter
- `CounterNotifier`: StateNotifier untuk memanipulasi nilai counter
- `CounterProvider`: Provider yang mengekspos notifier dan state
- `CounterPage`: Widget UI yang menggunakan provider

### 2. API Integration

Contoh integrasi API dengan Riverpod, menunjukkan pengambilan data, loading state, dan error handling.

**Komponen**:

- `UserModel`: Model data untuk user
- `UserRepository`: Repository untuk mengambil data user dari API
- `UserService`: Service yang menambahkan caching pada repository
- `UserListState`: State untuk daftar user
- `UserListNotifier`: Notifier untuk mengelola state user list
- `UserListProvider`: Provider untuk mengekspos notifier dan state
- `UserListPage`: Widget UI yang menampilkan daftar user

### 3. Pagination

Contoh implementasi pagination untuk memuat data secara bertahap.

**Komponen**:

- `ProductModel`: Model data untuk produk
- `ProductRepository`: Repository untuk mengambil data produk paginasi
- `ProductService`: Service yang menambahkan caching pada repository
- `ProductListState`: State yang menyimpan produk, halaman saat ini, dan flag hasMore
- `ProductListNotifier`: Notifier dengan metode loadMore untuk pagination
- `ProductListProvider`: Provider untuk mengekspos notifier dan state
- `ProductListPage`: Widget UI yang menampilkan daftar produk dengan infinite scroll

### 4. Form Handling

Contoh penanganan form dan validasi dengan Riverpod.

**Komponen**:

- `LoginFormState`: State yang menyimpan nilai form dan error
- `LoginFormNotifier`: Notifier dengan metode untuk update field dan validasi
- `LoginFormProvider`: Provider untuk mengekspos notifier dan state
- `LoginFormPage`: Widget UI yang menampilkan form login dengan validasi

### 5. Dependency Injection

Contoh pattern injeksi dependensi dengan Riverpod untuk memudahkan testing dan modularitas.

**Komponen**:

- `AppConfig`: Konfigurasi aplikasi
- `ApiClient`: Client HTTP
- `AuthService`: Service otentikasi
- `UserRepository`: Repository yang bergantung pada ApiClient
- `Providers`: Berbagai provider yang menunjukkan cara dependency injection
- `App`: Widget yang menggunakan provider yang di-injeksi

### 6. Caching

Contoh implementasi caching untuk data dengan Riverpod.

**Komponen**:

- `CacheService`: Service untuk mengelola cache
- `PokemonModel`: Model data untuk pokemon
- `PokemonRepository`: Repository untuk mengambil data pokemon
- `PokemonService`: Service yang mengimplementasikan caching
- `PokemonListState`: State untuk daftar pokemon
- `PokemonListNotifier`: Notifier dengan metode forceRefresh untuk memperbarui cache
- `PokemonListProvider`: Provider untuk mengekspos notifier dan state
- `PokemonListPage`: Widget UI yang menampilkan daftar pokemon dengan opsi refresh

## Praktik Terbaik

Contoh-contoh ini mendemonstrasikan praktik terbaik berikut:

1. **Pemisahan Concern**: Memisahkan UI, state management, dan logika bisnis
2. **Immutability**: Menjaga state immutable dan menggunakan copyWith untuk update
3. **Error Handling**: Penanganan error yang konsisten di seluruh aplikasi
4. **Optimasi Performa**: Menggunakan select untuk mencegah rebuild yang tidak perlu
5. **Testability**: Struktur yang memudahkan unit testing dan widget testing

## Catatan Penting

- Contoh ini bersifat ilustratif dan mungkin perlu disesuaikan untuk kebutuhan spesifik
- Beberapa contoh mungkin menggunakan mocking untuk simulasi API
- Fokus utama adalah pada pola dan struktur, bukan implementasi konkret dari setiap fitur
