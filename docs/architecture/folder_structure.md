# Struktur Folder Aplikasi

## Panduan Struktur Folder

Struktur folder aplikasi mengikuti prinsip pemisahan tanggung jawab (separation of concerns) dan memisahkan kode berdasarkan lapisan dan fitur.

```
lib/
├── core/                   # Komponen inti dan utilitas
│   ├── base/               # Kelas dasar (BaseState, BaseStateNotifier, dll)
│   ├── di/                 # Dependency Injection
│   ├── mahas/              # Komponen mahas dan services
│   ├── theme/              # Tema aplikasi
│   └── utils/              # Utilitas dan helpers
│
├── data/                   # Lapisan data
│   ├── models/             # Model data
│   └── datasource/         # Sumber data
│       ├── network/        # Data dari jaringan
│       │   ├── repository/ # Repository untuk mengelola data
│       │   └── service/    # Service untuk logika bisnis
│       └── local/          # Data lokal
│           ├── repository/ # Repository lokal
│           └── service/    # Service lokal
│
├── presentation/           # Lapisan presentasi
│   ├── providers/          # Provider Riverpod (berdasarkan fitur)
│   │   └── feature_name/   # Folder per fitur
│   │       ├── feature_state.dart
│   │       ├── feature_notifier.dart
│   │       └── feature_provider.dart
│   ├── pages/              # Halaman UI
│   │   └── feature_name/   # Folder per fitur
│   │       ├── feature_page.dart
│   │       └── widgets/    # Widget khusus untuk fitur
│   ├── widgets/            # Widget yang dapat digunakan ulang
│   └── routes/             # Konfigurasi routing
```

## Konvensi Penamaan File

Konsistensi penamaan file sangat penting untuk memelihara kode. Berikut konvensi yang digunakan:

1. **Snake Case untuk Nama File**: Semua file menggunakan `snake_case`
2. **Akhiran Tipe File**:
   - Model: `*_model.dart`
   - Repository: `*_repository.dart`
   - Service: `*_service.dart`
   - State: `*_state.dart`
   - Notifier: `*_notifier.dart`
   - Provider: `*_provider.dart`
   - Page: `*_page.dart`
   - Widget: `*_widget.dart` atau `*_card.dart`, `*_item.dart`, dll.

## Pengelompokan Berdasarkan Fitur

Aplikasi mengatur kode berdasarkan fitur, terutama di bagian presentation. Ini memastikan:

1. Kode yang terkait dengan fitur tertentu berada di tempat yang sama
2. Pemeliharaan dan pengembangan lebih mudah
3. Navigasi kode lebih intuitif

## Penataan Komponen

Diagram berikut menunjukkan bagaimana komponen-komponen saling terhubung:

```
┌─────────────┐       ┌───────────────┐       ┌───────────────┐
│    Model    │──────▶│  Repository   │──────▶│    Service    │
└─────────────┘       └───────────────┘       └───────┬───────┘
                                                     │
                                                     ▼
┌─────────────┐       ┌───────────────┐       ┌───────────────┐
│   Provider  │◀──────│    Notifier   │◀──────│     State     │
└─────────────┘       └───────────────┘       └───────────────┘
                            │
                            ▼
                      ┌───────────────┐
                      │     Page      │
                      └───────────────┘
```
