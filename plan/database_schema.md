# Skema Database Todo App

Dokumen ini berisi skema database SQLite untuk aplikasi Todo. Database ini dirancang untuk mendukung semua fitur aplikasi termasuk pengelolaan todo/task, sub-task, tagging, notifikasi, dan pengaturan pengguna.

## Tabel

### 1. `todos` - Tabel Utama Todo/Task

```sql
CREATE TABLE todos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    due_date DATETIME NOT NULL,
    is_repeatable BOOLEAN DEFAULT 0,
    with_notification BOOLEAN DEFAULT 0,
    notification_before INTEGER DEFAULT 30, -- dalam menit
    priority TEXT CHECK(priority IN ('high', 'normal', 'low')) DEFAULT 'normal',
    is_completed BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 2. `subtasks` - Tabel Sub-Task

```sql
CREATE TABLE subtasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    is_completed BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES todos(id) ON DELETE CASCADE
);
```

### 3. `tags` - Tabel Master Tag

```sql
CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    color TEXT, -- untuk menyimpan warna tag dalam format hex
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 4. `todo_tags` - Tabel Relasi Todo-Tag

```sql
CREATE TABLE todo_tags (
    todo_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (todo_id, tag_id),
    FOREIGN KEY (todo_id) REFERENCES todos(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);
```

### 5. `settings` - Tabel Pengaturan

```sql
CREATE TABLE settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_name TEXT,
    profile_image_path TEXT,
    is_dark_mode BOOLEAN DEFAULT 0,
    language TEXT CHECK(language IN ('en', 'id')) DEFAULT 'en',
    last_backup DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 6. `todo_history` - Tabel Riwayat Aktivitas Todo

```sql
CREATE TABLE todo_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id INTEGER NOT NULL,
    action TEXT NOT NULL, -- 'created', 'completed', 'updated'
    action_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (todo_id) REFERENCES todos(id) ON DELETE CASCADE
);
```

## Relasi Database

1. `todos` ↔ `subtasks`: One-to-many (satu todo dapat memiliki banyak subtask)
2. `todos` ↔ `tags`: Many-to-many (melalui junction table `todo_tags`)
3. `todos` ↔ `todo_history`: One-to-many (satu todo memiliki banyak catatan history)

## Catatan Implementasi

- Saat membuka koneksi database dengan SQFLite, aktifkan foreign key support:

  ```dart
  final db = await openDatabase(
    'todo_app.db',
    version: 1,
    onCreate: _createDb,
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
  );
  ```

- SQLite tidak memiliki tipe data khusus untuk DateTime, sehingga tanggal dan waktu disimpan sebagai TEXT dalam format ISO8601 (YYYY-MM-DD HH:MM:SS)

- Nilai boolean disimpan sebagai INTEGER (0 untuk false, 1 untuk true)

- Untuk fitur statistik dan tracking, gunakan tabel `todo_history` dan query aggregation

- Pastikan untuk mengimplementasikan mekanisme update kolom `updated_at` saat record dimodifikasi
