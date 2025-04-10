import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/services/logger_service.dart';

/// Helper class untuk mengelola koneksi database SQLite dan operasi dasar
class DBLocal {
  static final DBLocal _instance = DBLocal._internal();
  static Database? _database;

  // Constructor singleton
  factory DBLocal() => _instance;
  DBLocal._internal();

  // Nama database dan versi
  static const String _databaseName = "todo_app.db";
  static const int _databaseVersion = 1;

  // Nama tabel
  static const String tableTodo = 'todo';
  static const String tableTodoTag = 'todo_tag';
  static const String tableTag = 'tag';
  static const String tableSubtask = 'subtask';
  static const String tableSettings = 'settings';

  // Logger
  final LoggerService _logger = LoggerService.instance;

  // Mendapatkan instance database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<Database> _initDatabase() async {
    try {
      _logger.d('Initializing SQLite database...');

      // Get document directory
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);

      // Open the database
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
      );
    } catch (e) {
      _logger.e('Error initializing database: $e');
      rethrow;
    }
  }

  // Konfigurasi database untuk foreign key constraints
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Membuat tabel saat database dibuat
  Future _onCreate(Database db, int version) async {
    _logger.d('Creating database tables...');

    // Tabel todo (daftar todo)
    await db.execute('''
      CREATE TABLE $tableTodo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT,
        priority INTEGER DEFAULT 0,
        status INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tabel tag (daftar tag)
    await db.execute('''
      CREATE TABLE $tableTag (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        color TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Tabel todo_tag (relasi many-to-many todo dan tag)
    await db.execute('''
      CREATE TABLE $tableTodoTag (
        todo_id INTEGER,
        tag_id INTEGER,
        created_at TEXT NOT NULL,
        PRIMARY KEY (todo_id, tag_id),
        FOREIGN KEY (todo_id) REFERENCES $tableTodo (id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES $tableTag (id) ON DELETE CASCADE
      )
    ''');

    // Tabel subtask (subtask dari todo)
    await db.execute('''
      CREATE TABLE $tableSubtask (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        todo_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        is_completed INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (todo_id) REFERENCES $tableTodo (id) ON DELETE CASCADE
      )
    ''');

    // Tabel settings (pengaturan aplikasi)
    await db.execute('''
      CREATE TABLE $tableSettings (
        key TEXT PRIMARY KEY,
        value TEXT,
        last_updated TEXT
      )
    ''');

    _logger.d('Database tables created successfully');
  }

  // Upgrade database jika versi berubah
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _logger.d('Upgrading database from v$oldVersion to v$newVersion');

    if (oldVersion < 2) {
      // Tambahkan migrasi untuk versi 2 di sini
    }
  }

  // CRUD Operations

  /// Insert data ke dalam tabel
  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      Database db = await database;
      return await db.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      _logger.e('Error inserting data into $table: $e');
      rethrow;
    }
  }

  /// Insert batch data ke dalam tabel
  Future<int> insertBatch(
    String table,
    List<Map<String, dynamic>> dataList,
  ) async {
    int count = 0;
    try {
      Database db = await database;
      Batch batch = db.batch();

      for (var data in dataList) {
        batch.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      List<Object?> results = await batch.commit(noResult: false);
      count = results.length;
      return count;
    } catch (e) {
      _logger.e('Error batch inserting data into $table: $e');
      rethrow;
    }
  }

  /// Update data di tabel
  Future<int> update(
    String table,
    Map<String, dynamic> data,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    try {
      Database db = await database;
      return await db.update(
        table,
        data,
        where: whereClause,
        whereArgs: whereArgs,
      );
    } catch (e) {
      _logger.e('Error updating data in $table: $e');
      rethrow;
    }
  }

  /// Delete data dari tabel
  Future<int> delete(
    String table,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    try {
      Database db = await database;
      return await db.delete(table, where: whereClause, whereArgs: whereArgs);
    } catch (e) {
      _logger.e('Error deleting data from $table: $e');
      rethrow;
    }
  }

  /// Query semua data dari tabel
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    try {
      Database db = await database;
      return await db.query(table);
    } catch (e) {
      _logger.e('Error querying all data from $table: $e');
      rethrow;
    }
  }

  /// Query data dengan kondisi
  Future<List<Map<String, dynamic>>> queryWhere(
    String table,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    try {
      Database db = await database;
      return await db.query(table, where: whereClause, whereArgs: whereArgs);
    } catch (e) {
      _logger.e('Error querying data from $table with condition: $e');
      rethrow;
    }
  }

  /// Query dengan SQL kustom
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    try {
      Database db = await database;
      return await db.rawQuery(sql, arguments);
    } catch (e) {
      _logger.e('Error executing raw query: $e');
      rethrow;
    }
  }

  /// Cek apakah tabel memiliki data
  Future<bool> hasData(String table) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(table, limit: 1);
      return result.isNotEmpty;
    } catch (e) {
      _logger.e('Error checking if $table has data: $e');
      return false;
    }
  }

  /// Dapatkan jumlah data dalam tabel
  Future<int> getCount(String table) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $table',
      );
      int count = result.first['count'] as int;
      return count;
    } catch (e) {
      _logger.e('Error getting count from $table: $e');
      return 0;
    }
  }

  /// Hapus semua data di tabel
  Future<int> clearTable(String table) async {
    try {
      Database db = await database;
      return await db.delete(table);
    } catch (e) {
      _logger.e('Error clearing table $table: $e');
      rethrow;
    }
  }

  /// Periksa jika key ada di tabel settings
  Future<bool> hasSetting(String key) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        tableSettings,
        where: 'key = ?',
        whereArgs: [key],
      );
      return result.isNotEmpty;
    } catch (e) {
      _logger.e('Error checking if setting exists: $e');
      return false;
    }
  }

  /// Dapatkan nilai setting
  Future<String?> getSetting(String key) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        tableSettings,
        columns: ['value'],
        where: 'key = ?',
        whereArgs: [key],
      );
      if (result.isNotEmpty) {
        return result.first['value'] as String?;
      }
      return null;
    } catch (e) {
      _logger.e('Error getting setting value: $e');
      return null;
    }
  }

  /// Simpan setting dengan timestamp
  Future<int> saveSetting(String key, String value) async {
    try {
      Database db = await database;
      return await db.insert(tableSettings, {
        'key': key,
        'value': value,
        'last_updated': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      _logger.e('Error saving setting: $e');
      rethrow;
    }
  }

  /// Dapatkan timestamp terakhir update untuk setting
  Future<DateTime?> getSettingLastUpdated(String key) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        tableSettings,
        columns: ['last_updated'],
        where: 'key = ?',
        whereArgs: [key],
      );
      if (result.isNotEmpty && result.first['last_updated'] != null) {
        return DateTime.parse(result.first['last_updated'] as String);
      }
      return null;
    } catch (e) {
      _logger.e('Error getting setting last updated: $e');
      return null;
    }
  }

  /// Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
