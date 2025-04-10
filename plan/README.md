# Todo App - Dokumentasi Perancangan

Repositori ini berisi dokumentasi perancangan aplikasi Todo dengan Flutter dan SQLite. Dokumen ini berfungsi sebagai panduan dalam pengembangan aplikasi.

## Dokumen Perancangan

1. **Skema Database** ([database_schema.md](database_schema.md))

   - Struktur tabel dan relasi
   - SQL untuk pembuatan database
   - Relasi antar tabel
   - Catatan implementasi SQLite

2. **Implementasi Database** ([database_implementation.md](database_implementation.md))

   - Model classes
   - Database helper
   - Repository pattern
   - Contoh CRUD operations
   - Export dan import database

3. **Desain UI** ([ui_design.md](ui_design.md))

   - Struktur halaman
   - Komponen UI
   - Tema dan visual
   - Animasi dan transisi
   - Strategi responsif
   - Accessibility

4. **Roadmap Pengembangan** ([development_roadmap.md](development_roadmap.md))
   - Timeline dan milestone
   - Pembagian tugas per fase
   - Feature backlog
   - Testing strategy
   - Deployment strategy

## Fitur Utama

Aplikasi Todo ini memiliki fitur-fitur sebagai berikut:

1. **Manajemen Task/Todo**

   - Judul, deskripsi, tanggal dan waktu
   - Sub-tasks
   - Tagging (custom)
   - Prioritas (high, normal, low)
   - Notifikasi pengingat
   - Repeatable tasks

2. **Tampilan Today**

   - List task khusus hari ini
   - Ordering berdasarkan prioritas
   - Swipe actions untuk edit dan delete

3. **Calendar View**

   - Tampilan kalender bulanan
   - Marker untuk tanggal dengan task
   - List task per tanggal

4. **Statistik**

   - Ringkasan jumlah task
   - Activity tracker (mirip GitHub)
   - Distribusi tag (pie chart)
   - History task yang selesai

5. **Profil & Pengaturan**
   - Profil pengguna
   - Theme switching (light/dark)
   - Language switching (en/id)
   - Export/import database
   - Export ke CSV

## Teknologi

- **Frontend**: Flutter
- **State Management**: Riverpod
- **Database**: SQLite/SQFLite
- **Localization**: Flutter Intl
- **Charts**: fl_chart

## Struktur Aplikasi

Aplikasi mengikuti struktur folder yang telah didefinisikan dalam project_structure.mdc:

```
lib/
├── core/
│   ├── base/
│   ├── theme/
│   ├── utils/
│   ├── di/
│   └── ...
├── data/
│   ├── models/
│   └── datasource/
│       ├── network/
│       └── local/
├── presentation/
│   ├── providers/
│   ├── pages/
│   ├── widgets/
│   └── routes/
└── main.dart
```

## Petunjuk Penggunaan Dokumen

1. Mulai dengan memahami roadmap pengembangan (`development_roadmap.md`)
2. Pelajari skema database (`database_schema.md`) untuk memahami struktur data
3. Gunakan pedoman implementasi database (`database_implementation.md`) saat mengembangkan lapisan data
4. Ikuti desain UI (`ui_design.md`) untuk memastikan konsistensi visual
5. Tandai progres di roadmap seiring pengembangan

## Next Steps

1. Setup struktur proyek sesuai dokumentasi
2. Implementasi database dasar
3. Mulai pengembangan UI untuk halaman utama
4. Kembangkan fitur sesuai dengan prioritas di roadmap
