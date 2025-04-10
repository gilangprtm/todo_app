# Desain UI Aplikasi Todo

Dokumen ini menjelaskan rencana UI untuk aplikasi Todo, termasuk struktur halaman, komponen, dan alur navigasi.

## Struktur Halaman

### 1. Splash Screen

- Logo aplikasi di tengah
- Transisi otomatis ke Onboarding (pertama kali) atau Home (selanjutnya)

### 2. Onboarding

- 3-4 slide yang menjelaskan fitur utama aplikasi
- Setiap slide memiliki:
  - Ilustrasi/animasi
  - Judul fitur
  - Deskripsi singkat
- Tombol Skip di pojok kanan atas
- Tombol Next/Get Started di bagian bawah
- Indikator halaman (dots) di bawah

### 3. Home Page (Fitur 1)

- Header dengan:
  - Tanggal hari ini
  - Salam berdasarkan waktu (Selamat Pagi/Siang/Sore/Malam)
  - Avatar user (di pojok kanan)
- Section "Task Hari Ini"
  - Menampilkan jumlah task untuk hari ini
  - Progres bar menunjukkan persentase task yang selesai
- List Task:
  - Diurutkan berdasarkan prioritas dan waktu
  - Setiap item menampilkan:
    - Checkbox untuk menandai selesai
    - Judul task
    - Tag (dengan warna sesuai tag)
    - Indikator waktu
    - Badge prioritas (untuk high priority)
  - Swipe action:
    - Swipe kiri untuk delete
    - Swipe kanan untuk edit
- Empty state jika tidak ada task

### 4. Calendar Page (Fitur 2)

- Calendar view bulanan di bagian atas
  - Hari dengan task ditandai dengan dots
  - Hari ini di-highlight
- List task untuk tanggal yang dipilih di bawah kalender
  - Format sama dengan list di Home Page
  - Empty state jika tidak ada task di tanggal tersebut

### 5. Add Task Page

- Form input:
  - Text field untuk judul (required)
  - Text area untuk deskripsi (optional)
  - Date & time picker
  - Toggle untuk notifikasi
  - Dropdown untuk prioritas (High, Normal, Low)
  - Dropdown/chips untuk tags (multiple selection)
  - Toggle untuk repeatable
- Section untuk subtasks:
  - Text field untuk judul subtask
  - Tombol "+" untuk menambah subtask
  - Dapat menghapus subtask
- Tombol Cancel & Save di bagian bawah

### 6. Stats Page (Fitur 3)

- Section "Ringkasan":
  - Card jumlah total task
  - Card jumlah task selesai
  - Card jumlah task belum selesai
- Section "Activity Tracker":
  - Grid mirip GitHub contribution chart
  - Warna grid menunjukkan intensitas aktivitas
  - Tooltip menampilkan detail saat diklik
- Section "Tag Distribution":
  - Pie chart menampilkan distribusi tag
  - Legend menampilkan nama tag dan warna
- Section "History":
  - Date picker untuk memilih tanggal
  - List task yang selesai pada tanggal tersebut
  - Empty state jika tidak ada task selesai

### 7. Profile & Settings Page (Fitur 4)

- Header dengan avatar dan nama pengguna
- Section pengaturan profil:
  - Input nama
  - Upload foto
- Section pengaturan umum:
  - Toggle tema gelap
  - Dropdown bahasa (Inggris, Indonesia)
  - Slider/dropdown waktu notifikasi default
- Section backup & export:
  - Tombol export database
  - Tombol import database
  - Tombol export ke CSV
  - Informasi backup terakhir
- Section about:
  - Versi aplikasi
  - Informasi pengembang

## Navigasi

- Bottom navigation bar dengan 5 tab:
  - Home (ikon rumah)
  - Calendar (ikon kalender)
  - Add (ikon + di tengah, lebih besar)
  - Stats (ikon grafik)
  - Profile (ikon user)

## Tema dan Visual

### Tema Terang

- Background: White (#FFFFFF)
- Surface: Light Gray (#F5F5F5)
- Primary: Blue (#2196F3)
- Secondary: Teal (#009688)
- Accent: Pink (#FF4081)
- Text Primary: Dark Gray (#212121)
- Text Secondary: Gray (#757575)

### Tema Gelap

- Background: Dark Gray (#121212)
- Surface: Gray (#1E1E1E)
- Primary: Light Blue (#90CAF9)
- Secondary: Light Teal (#80CBC4)
- Accent: Light Pink (#FF80AB)
- Text Primary: White (#FFFFFF)
- Text Secondary: Light Gray (#B0B0B0)

### Prioritas Task

- High: Red (#F44336)
- Normal: Orange (#FF9800)
- Low: Green (#4CAF50)

## Komponen Umum

### Task Item

```
┌─────────────────────────────────────────┐
│ ○ Meeting with Client          12:30 PM │
│   [Work] [Project]                 !    │
│   ● Prepare presentation             ⋮  │
│   ○ Bring documents                     │
└─────────────────────────────────────────┘
```

### Empty State

```
┌─────────────────────────────────────────┐
│                                         │
│                 [Icon]                  │
│                                         │
│          No tasks for today             │
│                                         │
│            + Add New Task               │
│                                         │
└─────────────────────────────────────────┘
```

### Calendar Cell

```
┌─────────┐
│    12   │
│    ••   │
└─────────┘
```

## Animasi & Transisi

- Fade transition antar halaman
- Slide up animation untuk Add Task page
- Subtle bounce animation untuk checkbox completion
- Swipe animations dengan haptic feedback
- Pull-to-refresh dengan custom animation

## Strategi Responsif

- Menggunakan layout yang dapat beradaptasi dengan ukuran layar
- Grid layout untuk Stats page yang dapat berubah column count
- Margin dan padding yang proporsional dengan ukuran layar
- Text size yang responsif

## Accessibility

- Support untuk dynamic text sizing
- Kontras warna yang baik untuk readability
- Support untuk screen reader
- Semua interactive elements memiliki minimal touch target 48x48px
