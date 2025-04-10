# Layanan Caching

## Pengenalan

Sistem caching di aplikasi ini dirancang untuk meningkatkan performa, mengurangi beban jaringan, dan memperbaiki pengalaman pengguna dengan menyimpan data yang diambil dari API untuk penggunaan berikutnya. Sistem ini menggunakan pendekatan hybrid LRU (Least Recently Used) dan TTL (Time To Live) untuk manajemen cache.

## Struktur Utama

```dart
class CacheService {
  static final CacheService _instance = CacheService._internal();

  // Cache storage
  final Map<String, CacheEntry> _cache = {};

  // Configuration
  int _maxCacheSize = 100;
  bool _isInited = false;

  // Access timestamps for LRU implementation
  final Map<String, DateTime> _lastAccessed = {};

  // Constructor
  factory CacheService() {
    return _instance;
  }

  CacheService._internal();

  // Methods...
}
```

## Model Data Cache

```dart
class CacheEntry {
  final dynamic data;
  final DateTime expiry;
  final String? tag;

  CacheEntry({
    required this.data,
    required this.expiry,
    this.tag,
  });

  bool get isExpired => DateTime.now().isAfter(expiry);
}
```

## Fitur Utama

### 1. Inisialisasi Cache

```dart
Future<void> init({
  int maxCacheSize = 100,
  bool clearOnInit = false,
}) async {
  if (_isInited && !clearOnInit) return;

  _maxCacheSize = maxCacheSize;

  if (clearOnInit) {
    await clear();
  }

  _isInited = true;

  // Clean expired entries
  _cleanExpiredEntries();
}
```

### 2. Menyimpan Data ke Cache

```dart
Future<void> put({
  required String key,
  required dynamic data,
  required Duration ttl,
  String? tag,
}) async {
  final expiry = DateTime.now().add(ttl);

  _cache[key] = CacheEntry(
    data: data,
    expiry: expiry,
    tag: tag,
  );

  _lastAccessed[key] = DateTime.now();

  // Enforce cache size limit
  _enforceCacheSizeLimit();
}
```

### 3. Mengambil Data dari Cache

```dart
dynamic get({
  required String key,
  bool updateAccessTime = true,
}) {
  final entry = _cache[key];

  if (entry == null) {
    return null;
  }

  if (entry.isExpired) {
    _cache.remove(key);
    _lastAccessed.remove(key);
    return null;
  }

  if (updateAccessTime) {
    _lastAccessed[key] = DateTime.now();
  }

  return entry.data;
}
```

### 4. Implementasi LRU

```dart
void _enforceCacheSizeLimit() {
  if (_cache.length <= _maxCacheSize) return;

  // Sort keys by last accessed time
  final sortedKeys = _lastAccessed.keys.toList()
    ..sort((a, b) => _lastAccessed[a]!.compareTo(_lastAccessed[b]!));

  // Remove oldest entries until we're under the limit
  final keysToRemove = sortedKeys.take(_cache.length - _maxCacheSize).toList();

  for (final key in keysToRemove) {
    _cache.remove(key);
    _lastAccessed.remove(key);
  }
}
```

### 5. Pembersihan Cache

```dart
Future<void> _cleanExpiredEntries() async {
  final expiredKeys = _cache.entries
    .where((entry) => entry.value.isExpired)
    .map((entry) => entry.key)
    .toList();

  for (final key in expiredKeys) {
    _cache.remove(key);
    _lastAccessed.remove(key);
  }
}
```

### 6. Memaksa Refresh dengan ForceRefresh

```dart
dynamic getWithUpdate({
  required String key,
  required bool forceRefresh,
  required Future<dynamic> Function() fetchFunction,
  required Duration ttl,
  String? tag,
}) async {
  if (!forceRefresh) {
    final cachedData = get(key: key);
    if (cachedData != null) {
      return cachedData;
    }
  }

  // Fetch fresh data
  final data = await fetchFunction();

  // Save to cache
  await put(
    key: key,
    data: data,
    ttl: ttl,
    tag: tag,
  );

  return data;
}
```

## Penggunaan dalam Service

Sistem caching digunakan oleh service melalui metode utilitas:

```dart
class BaseService {
  Future<T> cachedOperationAsync<T>({
    required String cacheKey,
    required int ttlMinutes,
    required Future<T> Function() fetchFunction,
    required String operationName,
    String? tag,
    bool forceRefresh = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final cacheService = CacheService();

    if (!forceRefresh) {
      final cachedData = cacheService.get(key: cacheKey);
      if (cachedData != null) {
        loginfo('$operationName: Cache hit for $cacheKey');

        if (fromJson != null && cachedData is Map<String, dynamic>) {
          return fromJson(cachedData);
        }

        return cachedData as T;
      }
    } else {
      loginfo('$operationName: Force refresh for $cacheKey');
    }

    // Cache miss or force refresh
    try {
      final data = await fetchFunction();

      // Store in cache
      await cacheService.put(
        key: cacheKey,
        data: data,
        ttl: Duration(minutes: ttlMinutes),
        tag: tag,
      );

      return data;
    } catch (e, stackTrace) {
      logError('$operationName: Error fetching data', e, stackTrace);
      rethrow;
    }
  }
}
```

## Statistik dan Monitoring Cache

```dart
Map<String, dynamic> getCacheStats() {
  final totalEntries = _cache.length;
  final totalSize = _cache.length;
  final expiredEntries = _cache.values.where((e) => e.isExpired).length;

  final tagStats = <String, int>{};

  for (final entry in _cache.values) {
    if (entry.tag != null) {
      tagStats[entry.tag!] = (tagStats[entry.tag!] ?? 0) + 1;
    }
  }

  return {
    'totalEntries': totalEntries,
    'totalSize': totalSize,
    'expiredEntries': expiredEntries,
    'cacheLimit': _maxCacheSize,
    'utilizationPercentage': totalEntries / _maxCacheSize * 100,
    'tagDistribution': tagStats,
  };
}
```

## Membersihkan Cache

```dart
Future<int> clearCacheByTag(String tag) async {
  final keysToRemove = _cache.entries
    .where((entry) => entry.value.tag == tag)
    .map((entry) => entry.key)
    .toList();

  for (final key in keysToRemove) {
    _cache.remove(key);
    _lastAccessed.remove(key);
  }

  return keysToRemove.length;
}

Future<void> clear() async {
  _cache.clear();
  _lastAccessed.clear();
}
```

## Pola Penggunaan dalam Service

Contoh penggunaan cache dalam service:

```dart
class PokemonService extends BaseService {
  final PokemonRepository _repository = PokemonRepository();

  Future<List<PokemonModel>> getPokemonList({
    int limit = 20,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'pokemon_list_${limit}_${offset}';

    return cachedOperationAsync(
      cacheKey: cacheKey,
      ttlMinutes: 60 * 24, // 1 day
      forceRefresh: forceRefresh,
      operationName: 'PokemonService.getPokemonList',
      fetchFunction: () async {
        return await _repository.getPokemonList(limit: limit, offset: offset);
      },
      tag: 'PokemonService',
    );
  }

  Future<void> clearCache() async {
    final cacheService = CacheService();
    await cacheService.clearCacheByTag('PokemonService');
  }
}
```

## Optimasi dan Pertimbangan

1. **Batasan Ukuran Cache**: Cache dibatasi hingga jumlah entri tertentu untuk mencegah penggunaan memori yang berlebihan.

2. **Strategi LRU**: Entri yang paling jarang diakses akan dihapus terlebih dahulu ketika cache mencapai batas ukuran.

3. **Strategi TTL**: Entri cache memiliki waktu kedaluwarsa untuk memastikan data tetap segar.

4. **Pengelompokan Tag**: Entri cache dikelompokkan berdasarkan tag untuk memudahkan pembersihan selektif.

5. **Pembersihan Otomatis**: Cache secara otomatis membersihkan entri yang kedaluwarsa saat inisialisasi.

6. **Force Refresh**: Parameter forceRefresh memungkinkan pembaruan cache secara paksa saat diperlukan.

## Pertimbangan untuk Production

1. **Persistensi**: Untuk produksi, pertimbangkan untuk menambahkan persistensi cache ke penyimpanan lokal atau SharedPreferences.

2. **Kompresi**: Untuk objek data besar, pertimbangkan untuk menambahkan kompresi untuk menghemat ruang.

3. **Enkripsi**: Untuk data sensitif, tambahkan enkripsi pada data cache.

4. **Metric dan Analitik**: Tambahkan logging dan metrik untuk memantau efektivitas cache (hit rate, miss rate, dll).

5. **Cache Warming**: Pertimbangkan strategi untuk pre-loading cache dengan data yang sering diakses saat startup aplikasi.
