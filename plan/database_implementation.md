# Implementasi Database di Flutter

Dokumen ini menjelaskan strategi implementasi database untuk aplikasi Todo menggunakan SQFLite di Flutter.

## Model Classes

Berikut adalah rekomendasi untuk model classes berdasarkan skema database:

### TodoModel

```dart
class TodoModel {
  final int? id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool isRepeatable;
  final bool withNotification;
  final int notificationBefore;
  final String priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubTaskModel> subTasks;
  final List<TagModel> tags;

  TodoModel({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.isRepeatable = false,
    this.withNotification = false,
    this.notificationBefore = 30,
    this.priority = 'normal',
    this.isCompleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.subTasks = const [],
    this.tags = const [],
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'is_repeatable': isRepeatable ? 1 : 0,
      'with_notification': withNotification ? 1 : 0,
      'notification_before': notificationBefore,
      'priority': priority,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['due_date']),
      isRepeatable: map['is_repeatable'] == 1,
      withNotification: map['with_notification'] == 1,
      notificationBefore: map['notification_before'],
      priority: map['priority'],
      isCompleted: map['is_completed'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isRepeatable,
    bool? withNotification,
    int? notificationBefore,
    String? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<SubTaskModel>? subTasks,
    List<TagModel>? tags,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isRepeatable: isRepeatable ?? this.isRepeatable,
      withNotification: withNotification ?? this.withNotification,
      notificationBefore: notificationBefore ?? this.notificationBefore,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subTasks: subTasks ?? this.subTasks,
      tags: tags ?? this.tags,
    );
  }
}
```

### SubTaskModel

```dart
class SubTaskModel {
  final int? id;
  final int todoId;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  SubTaskModel({
    this.id,
    required this.todoId,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo_id': todoId,
      'title': title,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SubTaskModel.fromMap(Map<String, dynamic> map) {
    return SubTaskModel(
      id: map['id'],
      todoId: map['todo_id'],
      title: map['title'],
      isCompleted: map['is_completed'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  SubTaskModel copyWith({
    int? id,
    int? todoId,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return SubTaskModel(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

### TagModel

```dart
class TagModel {
  final int? id;
  final String name;
  final String? color;
  final DateTime createdAt;

  TagModel({
    this.id,
    required this.name,
    this.color,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  TagModel copyWith({
    int? id,
    String? name,
    String? color,
    DateTime? createdAt,
  }) {
    return TagModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

### SettingsModel

```dart
class SettingsModel {
  final int? id;
  final String? userName;
  final String? profileImagePath;
  final bool isDarkMode;
  final String language;
  final DateTime? lastBackup;
  final DateTime createdAt;
  final DateTime updatedAt;

  SettingsModel({
    this.id,
    this.userName,
    this.profileImagePath,
    this.isDarkMode = false,
    this.language = 'en',
    this.lastBackup,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': userName,
      'profile_image_path': profileImagePath,
      'is_dark_mode': isDarkMode ? 1 : 0,
      'language': language,
      'last_backup': lastBackup?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      id: map['id'],
      userName: map['user_name'],
      profileImagePath: map['profile_image_path'],
      isDarkMode: map['is_dark_mode'] == 1,
      language: map['language'],
      lastBackup: map['last_backup'] != null
          ? DateTime.parse(map['last_backup'])
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  SettingsModel copyWith({
    int? id,
    String? userName,
    String? profileImagePath,
    bool? isDarkMode,
    String? language,
    DateTime? lastBackup,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SettingsModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      lastBackup: lastBackup ?? this.lastBackup,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

### TodoHistoryModel

```dart
class TodoHistoryModel {
  final int? id;
  final int todoId;
  final String action;
  final DateTime actionDate;

  TodoHistoryModel({
    this.id,
    required this.todoId,
    required this.action,
    DateTime? actionDate,
  }) : this.actionDate = actionDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo_id': todoId,
      'action': action,
      'action_date': actionDate.toIso8601String(),
    };
  }

  factory TodoHistoryModel.fromMap(Map<String, dynamic> map) {
    return TodoHistoryModel(
      id: map['id'],
      todoId: map['todo_id'],
      action: map['action'],
      actionDate: DateTime.parse(map['action_date']),
    );
  }
}
```

## DatabaseHelper

Berikut adalah class untuk inisialisasi dan mengelola database:

```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'todo_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onConfigure: _configureDatabase,
    );
  }

  Future<void> _configureDatabase(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Tabel todos
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        due_date DATETIME NOT NULL,
        is_repeatable BOOLEAN DEFAULT 0,
        with_notification BOOLEAN DEFAULT 0,
        notification_before INTEGER DEFAULT 30,
        priority TEXT CHECK(priority IN ('high', 'normal', 'low')) DEFAULT 'normal',
        is_completed BOOLEAN DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Tabel subtasks
    await db.execute('''
      CREATE TABLE subtasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        todo_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        is_completed BOOLEAN DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (todo_id) REFERENCES todos(id) ON DELETE CASCADE
      )
    ''');

    // Tabel tags
    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        color TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Tabel todo_tags
    await db.execute('''
      CREATE TABLE todo_tags (
        todo_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        PRIMARY KEY (todo_id, tag_id),
        FOREIGN KEY (todo_id) REFERENCES todos(id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
      )
    ''');

    // Tabel settings
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_name TEXT,
        profile_image_path TEXT,
        is_dark_mode BOOLEAN DEFAULT 0,
        language TEXT CHECK(language IN ('en', 'id')) DEFAULT 'en',
        last_backup DATETIME,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Tabel todo_history
    await db.execute('''
      CREATE TABLE todo_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        todo_id INTEGER NOT NULL,
        action TEXT NOT NULL,
        action_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (todo_id) REFERENCES todos(id) ON DELETE CASCADE
      )
    ''');

    // Inisialisasi data default
    await db.insert('settings', {
      'user_name': 'User',
      'is_dark_mode': 0,
      'language': 'en',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Inisialisasi beberapa tag default
    await _insertDefaultTags(db);
  }

  Future<void> _insertDefaultTags(Database db) async {
    final defaultTags = [
      {'name': 'Kerja', 'color': '#FF4081'},
      {'name': 'Belajar', 'color': '#3F51B5'},
      {'name': 'Rumah', 'color': '#4CAF50'},
      {'name': 'Proyek', 'color': '#FF9800'},
    ];

    for (var tag in defaultTags) {
      await db.insert('tags', {
        'name': tag['name'],
        'color': tag['color'],
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }
}
```

## Repository Layer

Contoh implementasi Repository untuk Todo:

```dart
class TodoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // CRUD untuk Todo
  Future<int> insertTodo(TodoModel todo) async {
    final db = await _databaseHelper.database;
    final todoId = await db.insert('todos', todo.toMap());

    // Insert sub-tasks jika ada
    if (todo.subTasks.isNotEmpty) {
      for (var subTask in todo.subTasks) {
        await db.insert('subtasks', {
          ...subTask.toMap(),
          'todo_id': todoId,
        });
      }
    }

    // Insert todo-tags jika ada
    if (todo.tags.isNotEmpty) {
      for (var tag in todo.tags) {
        if (tag.id != null) {
          await db.insert('todo_tags', {
            'todo_id': todoId,
            'tag_id': tag.id,
          });
        }
      }
    }

    // Catat history
    await db.insert('todo_history', {
      'todo_id': todoId,
      'action': 'created',
      'action_date': DateTime.now().toIso8601String(),
    });

    return todoId;
  }

  Future<TodoModel?> getTodoById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final todo = TodoModel.fromMap(maps.first);

    // Get subtasks
    final subTasksMaps = await db.query(
      'subtasks',
      where: 'todo_id = ?',
      whereArgs: [id],
    );
    final subTasks = subTasksMaps.map((e) => SubTaskModel.fromMap(e)).toList();

    // Get tags
    final tagsMaps = await db.rawQuery('''
      SELECT t.* FROM tags t
      INNER JOIN todo_tags tt ON t.id = tt.tag_id
      WHERE tt.todo_id = ?
    ''', [id]);
    final tags = tagsMaps.map((e) => TagModel.fromMap(e)).toList();

    return todo.copyWith(
      subTasks: subTasks,
      tags: tags,
    );
  }

  Future<List<TodoModel>> getTodosForToday() async {
    final db = await _databaseHelper.database;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'due_date >= ? AND due_date < ?',
      whereArgs: [today.toIso8601String(), tomorrow.toIso8601String()],
      orderBy: 'priority DESC, due_date ASC', // high, normal, low
    );

    return Future.wait(maps.map((map) async {
      final todoId = map['id'];
      final todo = TodoModel.fromMap(map);

      // Get subtasks
      final subTasksMaps = await db.query(
        'subtasks',
        where: 'todo_id = ?',
        whereArgs: [todoId],
      );
      final subTasks = subTasksMaps.map((e) => SubTaskModel.fromMap(e)).toList();

      // Get tags
      final tagsMaps = await db.rawQuery('''
        SELECT t.* FROM tags t
        INNER JOIN todo_tags tt ON t.id = tt.tag_id
        WHERE tt.todo_id = ?
      ''', [todoId]);
      final tags = tagsMaps.map((e) => TagModel.fromMap(e)).toList();

      return todo.copyWith(
        subTasks: subTasks,
        tags: tags,
      );
    }).toList());
  }

  // Contoh query untuk fitur Calendar
  Future<List<TodoModel>> getTodosByDate(DateTime date) async {
    final db = await _databaseHelper.database;
    final targetDate = DateTime(date.year, date.month, date.day);
    final nextDate = targetDate.add(Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'due_date >= ? AND due_date < ?',
      whereArgs: [targetDate.toIso8601String(), nextDate.toIso8601String()],
      orderBy: 'priority DESC, due_date ASC',
    );

    // Sama seperti getTodosForToday, load subtasks dan tags
    // Implementasi penuh sama seperti getTodosForToday
    // ...

    return []; // Placeholder, implementasikan sesuai kebutuhan
  }

  // Contoh query untuk fitur Stats
  Future<Map<String, dynamic>> getTodoStats() async {
    final db = await _databaseHelper.database;

    // Total todos
    final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM todos');
    final total = Sqflite.firstIntValue(totalResult) ?? 0;

    // Completed todos
    final completedResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM todos WHERE is_completed = 1'
    );
    final completed = Sqflite.firstIntValue(completedResult) ?? 0;

    // Incomplete todos
    final incomplete = total - completed;

    // Tag distribution
    final tagDistribution = await db.rawQuery('''
      SELECT t.name, t.color, COUNT(tt.todo_id) as count
      FROM tags t
      INNER JOIN todo_tags tt ON t.id = tt.tag_id
      GROUP BY t.id
      ORDER BY count DESC
    ''');

    return {
      'total': total,
      'completed': completed,
      'incomplete': incomplete,
      'tagDistribution': tagDistribution,
    };
  }

  // Update todo
  Future<int> updateTodo(TodoModel todo) async {
    final db = await _databaseHelper.database;

    // Update todo dengan timestamp baru
    final todoMap = todo.copyWith(updatedAt: DateTime.now()).toMap();
    final result = await db.update(
      'todos',
      todoMap,
      where: 'id = ?',
      whereArgs: [todo.id],
    );

    // Catat history
    await db.insert('todo_history', {
      'todo_id': todo.id,
      'action': 'updated',
      'action_date': DateTime.now().toIso8601String(),
    });

    return result;
  }

  // Marking todo as complete
  Future<int> completeTodo(int id) async {
    final db = await _databaseHelper.database;

    final result = await db.update(
      'todos',
      {
        'is_completed': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    // Catat history
    await db.insert('todo_history', {
      'todo_id': id,
      'action': 'completed',
      'action_date': DateTime.now().toIso8601String(),
    });

    return result;
  }

  // Delete todo
  Future<int> deleteTodo(int id) async {
    final db = await _databaseHelper.database;

    // Karena kita menggunakan ON DELETE CASCADE,
    // subtasks dan todo_tags akan otomatis dihapus
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

## Penerapan Repository Pattern

Dengan struktur kode di atas, kita dapat menerapkan Repository Pattern untuk memisahkan logic akses data dari business logic. Setiap fitur utama (Todo, Tag, Settings, dll) akan memiliki repository-nya sendiri yang berinteraksi dengan database.

Dalam konteks aplikasi Todo dengan Riverpod, repository ini akan digunakan oleh State Notifier untuk mengelola state aplikasi.

## Export dan Import Database

Untuk fitur backup dan restore, tambahkan method berikut di DatabaseHelper:

```dart
Future<String> exportDatabase() async {
  final db = await database;
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'todo_app.db');

  // Direktori untuk backup
  final documentsDir = await getApplicationDocumentsDirectory();
  final backupPath = join(documentsDir.path, 'todo_app_backup.db');

  // Copy database file
  await File(path).copy(backupPath);

  // Update last_backup di settings
  await db.update(
    'settings',
    {'last_backup': DateTime.now().toIso8601String()},
    where: 'id = 1',
  );

  return backupPath;
}

Future<bool> importDatabase(String backupPath) async {
  try {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo_app.db');

    // Close existing database
    await _database?.close();
    _database = null;

    // Copy backup to database location
    await File(backupPath).copy(path);

    // Reinitialize database
    _database = await _initDatabase();
    return true;
  } catch (e) {
    print('Error importing database: $e');
    return false;
  }
}

Future<String> exportToCsv() async {
  final db = await database;
  final documentsDir = await getApplicationDocumentsDirectory();
  final csvPath = join(documentsDir.path, 'todos_export.csv');
  final file = File(csvPath);

  // Get todos with their tags
  final todos = await db.rawQuery('''
    SELECT
      t.id, t.title, t.description, t.due_date, t.priority, t.is_completed,
      GROUP_CONCAT(tag.name, ', ') as tags
    FROM todos t
    LEFT JOIN todo_tags tt ON t.id = tt.todo_id
    LEFT JOIN tags tag ON tt.tag_id = tag.id
    GROUP BY t.id
  ''');

  // Create CSV header
  final csvContent = StringBuffer(
      'ID,Title,Description,Due Date,Priority,Completed,Tags\n');

  // Add rows
  for (var todo in todos) {
    csvContent.writeln(
        '${todo['id']},${todo['title']},"${todo['description'] ?? ''}",${todo['due_date']},${todo['priority']},${todo['is_completed'] == 1 ? 'Yes' : 'No'},"${todo['tags'] ?? ''}"');
  }

  // Write to file
  await file.writeAsString(csvContent.toString());
  return csvPath;
}
```

Ini adalah struktur dasar untuk implementasi database di Flutter menggunakan SQFLite, yang mendukung semua fitur yang Anda sebutkan dalam perancangan aplikasi Todo.
