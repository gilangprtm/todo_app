import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger_service.dart';

/// Service untuk mengelola caching data aplikasi
/// Menyediakan mekanisme caching dinamis yang dapat dikonfigurasi
class CacheService {
  // Singleton pattern
  static final CacheService _instance = CacheService._internal();
  static CacheService get instance => _instance;

  // Logger
  final LoggerService _logger = LoggerService.instance;

  // Shared Preferences instance
  SharedPreferences? _prefs;

  // Tabel TTL (Time-To-Live) untuk setiap cache key
  final Map<String, int> _cacheTTL = {};

  // Tabel ukuran data untuk setiap cache key (dalam bytes)
  final Map<String, int> _cacheSizes = {};

  // Tabel timestamp akses terakhir untuk LRU (Least Recently Used)
  final Map<String, int> _lastAccessTimes = {};

  // Total ukuran cache saat ini (dalam bytes)
  int _totalCacheSize = 0;

  // Batas maksimum ukuran cache (50MB default)
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB dalam bytes

  // Default TTL dalam menit
  static const int defaultTTLMinutes = 60; // 1 jam

  // Prefix untuk key cache
  static const String cacheKeyPrefix = 'cache_';
  static const String ttlKeyPrefix = 'ttl_';
  static const String sizeKeyPrefix = 'size_';
  static const String lruKeyPrefix = 'lru_';

  // Constructor
  CacheService._internal();

  /// Inisialisasi CacheService
  Future<void> initialize() async {
    if (_prefs != null) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.i('Cache Service initialized successfully', tag: 'APP');

      // Load existing TTL settings
      _loadCacheTTLSettings();

      // Load cache size settings
      _loadCacheSizeSettings();

      // Load LRU settings
      _loadLRUSettings();

      // Secara asinkron bersihkan cache yang expired
      // Ditunda untuk tidak mengganggu startup
      Future.delayed(const Duration(seconds: 3), () {
        _performPreemptiveCleaning();
      });
    } catch (e) {
      _logger.e('Failed to initialize Cache Service', error: e, tag: 'APP');
      rethrow;
    }
  }

  /// Load TTL settings dari storage
  void _loadCacheTTLSettings() {
    const ttlKey = '${ttlKeyPrefix}settings';
    final ttlJson = _prefs?.getString(ttlKey);

    if (ttlJson != null) {
      try {
        final Map<String, dynamic> ttlMap = jsonDecode(ttlJson);
        ttlMap.forEach((key, value) {
          if (value is int) {
            _cacheTTL[key] = value;
          }
        });
        _logger.d('Loaded TTL settings for ${_cacheTTL.length} cache keys',
            tag: 'APP');
      } catch (e) {
        _logger.e('Error loading TTL settings', error: e, tag: 'APP');
      }
    }
  }

  /// Load cache size settings dari storage
  void _loadCacheSizeSettings() {
    const sizeKey = '${sizeKeyPrefix}settings';
    final sizeJson = _prefs?.getString(sizeKey);

    if (sizeJson != null) {
      try {
        final Map<String, dynamic> sizeMap = jsonDecode(sizeJson);
        sizeMap.forEach((key, value) {
          if (value is int) {
            _cacheSizes[key] = value;
          }
        });

        // Hitung total ukuran cache
        _totalCacheSize = _cacheSizes.values.fold(0, (sum, size) => sum + size);

        _logger.d(
            'Loaded size settings for ${_cacheSizes.length} cache keys (Total: ${_formatSize(_totalCacheSize)})',
            tag: 'APP');
      } catch (e) {
        _logger.e('Error loading cache size settings', error: e, tag: 'APP');
      }
    }
  }

  /// Load LRU settings dari storage
  void _loadLRUSettings() {
    const lruKey = '${lruKeyPrefix}settings';
    final lruJson = _prefs?.getString(lruKey);

    if (lruJson != null) {
      try {
        final Map<String, dynamic> lruMap = jsonDecode(lruJson);
        lruMap.forEach((key, value) {
          if (value is int) {
            _lastAccessTimes[key] = value;
          }
        });
        _logger.d(
            'Loaded LRU settings for ${_lastAccessTimes.length} cache keys',
            tag: 'APP');
      } catch (e) {
        _logger.e('Error loading LRU settings', error: e, tag: 'APP');
      }
    }
  }

  /// Simpan TTL settings ke storage
  Future<void> _saveCacheTTLSettings() async {
    const ttlKey = '${ttlKeyPrefix}settings';
    await _prefs?.setString(ttlKey, jsonEncode(_cacheTTL));
  }

  /// Simpan cache size settings ke storage
  Future<void> _saveCacheSizeSettings() async {
    const sizeKey = '${sizeKeyPrefix}settings';
    await _prefs?.setString(sizeKey, jsonEncode(_cacheSizes));
  }

  /// Simpan LRU settings ke storage
  Future<void> _saveLRUSettings() async {
    const lruKey = '${lruKeyPrefix}settings';
    await _prefs?.setString(lruKey, jsonEncode(_lastAccessTimes));
  }

  /// Set TTL (Time-To-Live) untuk cache key tertentu
  /// [key] - Cache key
  /// [ttlMinutes] - Waktu TTL dalam menit, null untuk menghapus TTL
  Future<void> setCacheTTL(String key, int? ttlMinutes) async {
    await initialize();

    if (ttlMinutes == null) {
      _cacheTTL.remove(key);
    } else {
      _cacheTTL[key] = ttlMinutes;
    }

    await _saveCacheTTLSettings();
    _logger.d('Set TTL for $key to $ttlMinutes minutes', tag: 'APP');
  }

  /// Get TTL (Time-To-Live) untuk cache key tertentu
  /// [key] - Cache key
  /// Returns TTL dalam menit atau null jika tidak diset
  int? getCacheTTL(String key) {
    return _cacheTTL[key];
  }

  /// Perkirakan ukuran data dalam bytes
  int _estimateDataSize(dynamic data) {
    try {
      if (data == null) return 0;

      // String: 2 bytes per karakter
      if (data is String) return data.length * 2;

      // Numbers
      if (data is int) return 8;
      if (data is double) return 8;

      // Boolean
      if (data is bool) return 1;

      // Lists
      if (data is List<String>) {
        return data.fold(0, (sum, item) => sum + item.length * 2);
      }

      // Complex objects: encode to JSON and measure
      final jsonString = jsonEncode(data);
      return jsonString.length * 2; // UTF-16 encoding (2 bytes per char)
    } catch (e) {
      _logger.e('Error estimating data size', error: e, tag: 'APP');
      // Default fallback: 1KB
      return 1024;
    }
  }

  /// Format ukuran bytes menjadi string yang lebih mudah dibaca
  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Update timestamp akses terakhir untuk LRU
  void _updateLastAccessTime(String key) {
    _lastAccessTimes[key] = DateTime.now().millisecondsSinceEpoch;
  }

  /// Cek apakah data dengan key tertentu masih valid (belum expired)
  /// [key] - Cache key
  bool isValid(String key) {
    if (_prefs == null) return false;

    final fullKey = '$cacheKeyPrefix$key';
    final timestampKey = '${fullKey}_timestamp';

    // Cek apakah data ada di cache
    if (!_prefs!.containsKey(fullKey)) return false;
    if (!_prefs!.containsKey(timestampKey)) return false;

    // Ambil timestamp kapan data di-cache
    final timestamp = _prefs!.getInt(timestampKey);
    if (timestamp == null) return false;

    // Cek TTL
    final ttlMinutes = _cacheTTL[key] ?? defaultTTLMinutes;
    final cacheDuration = Duration(minutes: ttlMinutes);
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final expiryTime = cacheTime.add(cacheDuration);

    // Cek apakah masih valid
    final isStillValid = DateTime.now().isBefore(expiryTime);

    if (!isStillValid) {
      _logger.d('Cache for $key has expired', tag: 'APP');
    }

    return isStillValid;
  }

  /// Hitung persentase TTL yang sudah berlalu
  /// Returns nilai 0-100 (persentase)
  double _getTTLPercentage(String key) {
    if (_prefs == null) return 100;

    final fullKey = '$cacheKeyPrefix$key';
    final timestampKey = '${fullKey}_timestamp';

    if (!_prefs!.containsKey(timestampKey)) return 100;

    final timestamp = _prefs!.getInt(timestampKey);
    if (timestamp == null) return 100;

    final ttlMinutes = _cacheTTL[key] ?? defaultTTLMinutes;
    final cacheDuration = Duration(minutes: ttlMinutes).inMilliseconds;
    final cacheTime = timestamp;
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsed = now - cacheTime;

    if (cacheDuration <= 0) return 100;

    final percentage = (elapsed / cacheDuration) * 100;
    return percentage.clamp(0, 100);
  }

  /// Lakukan pembersihan cache preemptive saat startup
  Future<void> _performPreemptiveCleaning() async {
    try {
      // Periksa jika ukuran cache melebihi 80% dari batas maksimum
      if (_totalCacheSize > (maxCacheSize * 0.8)) {
        _logger.i(
            'Performing preemptive cache cleaning (current size: ${_formatSize(_totalCacheSize)})',
            tag: 'APP');

        // Bersihkan cache expired terlebih dahulu
        final expiredRemoved = await cleanExpiredCache();

        // Jika masih melebihi 80%, bersihkan berdasarkan LRU + TTL
        if (_totalCacheSize > (maxCacheSize * 0.8)) {
          final additionalRemoved = await _cleanByLRUAndTTL(
              targetSize:
                  (maxCacheSize * 0.6).toInt() // Target 60% dari maksimum
              );

          _logger.i(
              'Preemptive cleaning completed. Removed $expiredRemoved expired entries and $additionalRemoved additional entries',
              tag: 'APP');
        } else {
          _logger.i(
              'Preemptive cleaning completed. Removed $expiredRemoved expired entries',
              tag: 'APP');
        }
      }
    } catch (e) {
      _logger.e('Error in preemptive cache cleaning', error: e, tag: 'APP');
    }
  }

  /// Bersihkan cache berdasarkan LRU dan TTL
  /// [targetSize] - Target ukuran cache setelah pembersihan (dalam bytes)
  Future<int> _cleanByLRUAndTTL({required int targetSize}) async {
    await initialize();

    if (_totalCacheSize <= targetSize) return 0;

    try {
      // Buat daftar kandidat untuk dihapus (semua cache entries)
      final allKeys = _getCacheKeysList();

      // Tambahkan informasi untuk sorting berdasarkan prioritas
      List<MapEntry<String, double>> priorityList = [];

      for (final key in allKeys) {
        // Skip jika tidak ada di _cacheSizes (berarti sudah dihapus atau tidak valid)
        if (!_cacheSizes.containsKey(key)) continue;

        // Hitung skor prioritas berdasarkan TTL dan LRU
        double ttlFactor =
            _getTTLPercentage(key) / 100; // 0-1 berdasarkan persen TTL berlalu

        // LRU Factor: lebih lama tidak diakses = lebih tinggi skornya
        double lruFactor = 0;
        if (_lastAccessTimes.containsKey(key)) {
          final lastAccess = _lastAccessTimes[key]!;
          final now = DateTime.now().millisecondsSinceEpoch;
          final age = now - lastAccess;
          // Normalisasi: lebih tua = lebih tinggi prioritas (0-1)
          // Asumsikan 1 hari adalah maksimum (86400000 ms)
          lruFactor = (age / 86400000).clamp(0, 1);
        } else {
          // Jika tidak ada data akses, berikan skor tinggi
          lruFactor = 0.9;
        }

        // Skor gabungan: TTL + LRU, prioritaskan TTL dengan bobot lebih tinggi
        double combinedScore = (ttlFactor * 0.7) + (lruFactor * 0.3);

        // Masukkan ke daftar prioritas
        priorityList.add(MapEntry(key, combinedScore));
      }

      // Sort berdasarkan prioritas (skor tertinggi = hapus terlebih dahulu)
      priorityList.sort((a, b) => b.value.compareTo(a.value));

      int removedCount = 0;
      int freedSpace = 0;

      // Hapus keys dengan prioritas tertinggi sampai target ukuran tercapai
      for (final entry in priorityList) {
        final key = entry.key;

        if (!_cacheSizes.containsKey(key)) continue;

        final size = _cacheSizes[key] ?? 0;
        await remove(key);

        freedSpace += size;
        removedCount++;

        // Periksa apakah target ukuran sudah tercapai
        if (_totalCacheSize <= targetSize) break;
      }

      _logger.i(
          'Cleaned $removedCount entries by LRU+TTL strategy, freed ${_formatSize(freedSpace)}',
          tag: 'APP');
      return removedCount;
    } catch (e) {
      _logger.e('Error cleaning cache by LRU+TTL', error: e, tag: 'APP');
      return 0;
    }
  }

  /// Dapatkan daftar cache keys
  List<String> _getCacheKeysList() {
    final allKeys = _prefs!.getKeys();

    // Filter hanya data keys dengan prefix cache (bukan timestamp atau TTL)
    return allKeys
        .where((key) =>
            key.startsWith(cacheKeyPrefix) && !key.endsWith('_timestamp'))
        .map((key) => key.substring(cacheKeyPrefix.length))
        .toList();
  }

  /// Simpan data ke cache dengan key tertentu
  /// [key] - Cache key
  /// [data] - Data yang akan disimpan (Map, List, atau primitive type)
  /// [ttlMinutes] - Waktu TTL dalam menit (opsional)
  Future<bool> set(String key, dynamic data, {int? ttlMinutes}) async {
    await initialize();

    try {
      final fullKey = '$cacheKeyPrefix$key';
      final timestampKey = '${fullKey}_timestamp';
      final now = DateTime.now().millisecondsSinceEpoch;

      // Set TTL jika ditentukan
      if (ttlMinutes != null) {
        await setCacheTTL(key, ttlMinutes);
      }

      // Simpan timestamp
      await _prefs!.setInt(timestampKey, now);

      // Update LRU
      _updateLastAccessTime(key);
      await _saveLRUSettings();

      // Perkirakan ukuran data
      final dataSize = _estimateDataSize(data);

      // Periksa apakah data baru akan menyebabkan cache melebihi batas
      // Jika sudah ada entry dengan key yang sama, hitung perubahannya
      final oldSize = _cacheSizes[key] ?? 0;
      final newTotalSize = _totalCacheSize - oldSize + dataSize;

      // Jika melebihi batas, bersihkan cache berdasarkan prioritas
      if (newTotalSize > maxCacheSize) {
        _logger.d(
            'Cache size would exceed limit. Cleaning before adding new data.',
            tag: 'APP');

        // Bersihkan cache berdasarkan LRU + TTL
        await _cleanByLRUAndTTL(
            targetSize: (maxCacheSize * 0.8).toInt() - dataSize);
      }

      // Simpan data sesuai tipenya
      bool result;
      if (data is String) {
        result = await _prefs!.setString(fullKey, data);
      } else if (data is int) {
        result = await _prefs!.setInt(fullKey, data);
      } else if (data is double) {
        result = await _prefs!.setDouble(fullKey, data);
      } else if (data is bool) {
        result = await _prefs!.setBool(fullKey, data);
      } else if (data is List<String>) {
        result = await _prefs!.setStringList(fullKey, data);
      } else {
        // Konversi ke JSON string untuk tipe kompleks
        String jsonData;
        try {
          // Coba convert langsung
          jsonData = jsonEncode(data);
        } catch (e) {
          // Jika error, cek apakah ada method toJson()
          if (data != null &&
              data.runtimeType.toString().contains("PaginatedApiResponse")) {
            try {
              final jsonMap = (data as dynamic).toJson();
              jsonData = jsonEncode(jsonMap);
            } catch (_) {
              throw Exception(
                  'Data type ${data.runtimeType} tidak dapat dikonversi ke JSON dan tidak memiliki method toJson()');
            }
          } else {
            rethrow;
          }
        }

        result = await _prefs!.setString(fullKey, jsonData);
      }

      // Update cache size tracking
      if (result) {
        // Kurangi ukuran lama jika ada
        if (_cacheSizes.containsKey(key)) {
          _totalCacheSize -= _cacheSizes[key]!;
        }

        // Tambahkan ukuran baru
        _cacheSizes[key] = dataSize;
        _totalCacheSize += dataSize;

        // Simpan cache sizes
        await _saveCacheSizeSettings();

        _logger.d(
            'Cached data for $key (${_formatSize(dataSize)}), total cache size: ${_formatSize(_totalCacheSize)}',
            tag: 'APP');
      }

      return result;
    } catch (e) {
      _logger.e('Error caching data for $key', error: e, tag: 'APP');
      return false;
    }
  }

  /// Ambil data dari cache
  /// [key] - Cache key
  /// [defaultValue] - Nilai default jika tidak ada di cache atau sudah expired
  /// [type] - Tipe data yang diharapkan ('string', 'int', 'double', 'bool', 'stringList', 'json')
  /// Returns data dari cache atau defaultValue jika tidak ada/expired
  dynamic get(String key, {dynamic defaultValue, String type = 'json'}) {
    if (_prefs == null) return defaultValue;

    try {
      // Generate key
      final fullKey = '$cacheKeyPrefix$key';

      // Cek validitas
      if (!isValid(key)) return defaultValue;

      // Update LRU
      _updateLastAccessTime(key);
      _saveLRUSettings(); // Tidak perlu await dalam metode sync

      // Ambil data sesuai tipe
      switch (type.toLowerCase()) {
        case 'string':
          return _prefs!.getString(fullKey) ?? defaultValue;
        case 'int':
          return _prefs!.getInt(fullKey) ?? defaultValue;
        case 'double':
          return _prefs!.getDouble(fullKey) ?? defaultValue;
        case 'bool':
          return _prefs!.getBool(fullKey) ?? defaultValue;
        case 'stringlist':
          return _prefs!.getStringList(fullKey) ?? defaultValue;
        case 'json':
        default:
          final jsonData = _prefs!.getString(fullKey);
          if (jsonData == null) return defaultValue;

          try {
            return jsonDecode(jsonData);
          } catch (e) {
            _logger.e('Error decoding JSON for $key', error: e, tag: 'APP');
            return defaultValue;
          }
      }
    } catch (e) {
      _logger.e('Error retrieving cache for $key', error: e, tag: 'APP');
      return defaultValue;
    }
  }

  /// Hapus data dari cache
  /// [key] - Cache key
  Future<bool> remove(String key) async {
    await initialize();

    try {
      final fullKey = '$cacheKeyPrefix$key';
      final timestampKey = '${fullKey}_timestamp';

      // Kurangi ukuran cache jika ada
      if (_cacheSizes.containsKey(key)) {
        _totalCacheSize -= _cacheSizes[key]!;
        _cacheSizes.remove(key);
        await _saveCacheSizeSettings();
      }

      // Hapus data LRU
      if (_lastAccessTimes.containsKey(key)) {
        _lastAccessTimes.remove(key);
        await _saveLRUSettings();
      }

      // Hapus data dan timestamp
      await _prefs!.remove(fullKey);
      await _prefs!.remove(timestampKey);

      // Hapus TTL setting juga
      if (_cacheTTL.containsKey(key)) {
        _cacheTTL.remove(key);
        await _saveCacheTTLSettings();
      }

      _logger.d('Removed cache for $key', tag: 'APP');
      return true;
    } catch (e) {
      _logger.e('Error removing cache for $key', error: e, tag: 'APP');
      return false;
    }
  }

  /// Ambil data dengan cache, jika tidak ada atau expired, ambil dari source
  /// [key] - Cache key
  /// [fetchFunction] - Fungsi untuk mengambil data jika cache tidak ada/expired
  /// [ttlMinutes] - Waktu TTL dalam menit (opsional)
  /// [forceRefresh] - Paksa refresh dari source meskipun cache masih valid
  Future<T> getOrFetch<T>(
    String key,
    Future<T> Function() fetchFunction, {
    int? ttlMinutes,
    bool forceRefresh = false,
  }) async {
    await initialize();

    try {
      // Cek cache jika tidak dipaksa refresh
      if (!forceRefresh && isValid(key)) {
        _logger.d('Using cached data for $key', tag: 'APP');
        final cachedData = get(key);
        if (cachedData != null) {
          return cachedData as T;
        }
      }

      // Jika tidak ada di cache atau dipaksa refresh, ambil dari source
      _logger.d('Fetching fresh data for $key', tag: 'APP');
      final freshData = await fetchFunction();

      // Simpan ke cache
      await set(key, freshData, ttlMinutes: ttlMinutes);

      return freshData;
    } catch (e) {
      _logger.e('Error in getOrFetch for $key', error: e, tag: 'APP');
      rethrow;
    }
  }

  /// Hapus semua data cache
  Future<bool> clearAll() async {
    await initialize();

    try {
      // Ambil semua keys
      final allKeys = _prefs!.getKeys();

      // Filter hanya keys dengan prefix cache
      final cacheKeys = allKeys.where((key) =>
          key.startsWith(cacheKeyPrefix) ||
          key.startsWith(ttlKeyPrefix) ||
          key.startsWith(sizeKeyPrefix) ||
          key.startsWith(lruKeyPrefix));

      // Hapus semua cache keys
      for (final key in cacheKeys) {
        await _prefs!.remove(key);
      }

      // Reset TTL settings
      _cacheTTL.clear();
      await _saveCacheTTLSettings();

      // Reset cache size settings
      _cacheSizes.clear();
      _totalCacheSize = 0;
      await _saveCacheSizeSettings();

      // Reset LRU settings
      _lastAccessTimes.clear();
      await _saveLRUSettings();

      _logger.i('Cleared all cache data', tag: 'APP');
      return true;
    } catch (e) {
      _logger.e('Error clearing all cache', error: e, tag: 'APP');
      return false;
    }
  }

  /// Hapus cache yang sudah expired
  Future<int> cleanExpiredCache() async {
    await initialize();

    try {
      // Ambil semua keys
      final allKeys = _prefs!.getKeys();

      // Filter hanya data keys dengan prefix cache (bukan timestamp atau TTL)
      final cacheKeys = allKeys.where((key) =>
          key.startsWith(cacheKeyPrefix) && !key.endsWith('_timestamp'));

      int removedCount = 0;

      // Periksa setiap key
      for (final fullKey in cacheKeys) {
        // Extract key tanpa prefix
        final key = fullKey.substring(cacheKeyPrefix.length);

        // Cek validitas
        if (!isValid(key)) {
          // Hapus data yang expired
          await remove(key);
          removedCount++;
        }
      }

      _logger.i(
          'Cleaned $removedCount expired cache entries, current cache size: ${_formatSize(_totalCacheSize)}',
          tag: 'APP');
      return removedCount;
    } catch (e) {
      _logger.e('Error cleaning expired cache', error: e, tag: 'APP');
      return 0;
    }
  }

  /// Dapatkan statistik penggunaan cache
  Future<Map<String, dynamic>> getCacheStats() async {
    await initialize();

    try {
      // Ambil semua keys
      final allKeys = _prefs!.getKeys();

      // Filter hanya data keys dengan prefix cache (bukan timestamp atau TTL)
      final cacheKeys = allKeys
          .where((key) =>
              key.startsWith(cacheKeyPrefix) && !key.endsWith('_timestamp'))
          .map((key) => key.substring(cacheKeyPrefix.length))
          .toList();

      int validCount = 0;
      int expiredCount = 0;

      // Periksa setiap key
      for (final key in cacheKeys) {
        if (isValid(key)) {
          validCount++;
        } else {
          expiredCount++;
        }
      }

      return {
        'totalEntries': cacheKeys.length,
        'validEntries': validCount,
        'expiredEntries': expiredCount,
        'ttlEntries': _cacheTTL.length,
        'totalSize': _totalCacheSize,
        'totalSizeFormatted': _formatSize(_totalCacheSize),
        'maxSize': maxCacheSize,
        'maxSizeFormatted': _formatSize(maxCacheSize),
        'usagePercentage':
            '${(_totalCacheSize / maxCacheSize * 100).toStringAsFixed(2)}%',
      };
    } catch (e) {
      _logger.e('Error getting cache stats', error: e, tag: 'APP');
      return {
        'totalEntries': 0,
        'validEntries': 0,
        'expiredEntries': 0,
        'ttlEntries': 0,
        'totalSize': 0,
        'totalSizeFormatted': '0 B',
        'maxSize': maxCacheSize,
        'maxSizeFormatted': _formatSize(maxCacheSize),
        'usagePercentage': '0%',
      };
    }
  }
}
