import '../../data/datasource/network/db/dio_service.dart';
import '../services/cache_service.dart';
import '../services/logger_service.dart';
import '../services/performance_service.dart';

abstract class BaseRepository {
  final DioService dioService = DioService();
  final LoggerService logger = LoggerService.instance;

  void logInfo(String message, {String? tag}) {
    logger.i(message, tag: tag ?? 'Repository');
  }

  void logError(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
      tag: tag ?? 'Repository',
    );
  }

  void logDebug(String message, {String? tag}) {
    logger.d(message, tag: tag ?? 'Repository');
  }
}

abstract class BaseService {
  final LoggerService logger = LoggerService.instance;
  final PerformanceService performanceService = PerformanceService.instance;
  final CacheService cacheService = CacheService.instance;

  Future<T> performanceAsync<T>({
    required String operationName,
    required Future<T> Function() function,
    String? tag,
  }) async {
    return performanceService.measureAsync(
      operationName,
      function,
      tag: tag ?? "Service",
    );
  }

  void performance({
    required String operationName,
    required dynamic Function() function,
    String? tag,
  }) {
    return performanceService.measure(
      operationName,
      function,
      tag: tag ?? "Service",
    );
  }

  /// Metode untuk menjalankan operasi dengan caching yang dinamis
  /// [cacheKey] - Key untuk menyimpan hasil di cache
  /// [ttlMinutes] - Waktu cache berlaku dalam menit (opsional)
  /// [forceRefresh] - Abaikan cache dan paksa ambil data baru
  /// [operationName] - Nama operasi untuk logging performa
  /// [fetchFunction] - Fungsi yang dijalankan jika cache tidak ada/expired
  /// [fromJson] - Fungsi untuk mengkonversi data JSON ke tipe T yang diinginkan
  Future<T> cachedOperationAsync<T>({
    required String cacheKey,
    int? ttlMinutes,
    bool forceRefresh = false,
    required String operationName,
    required Future<T> Function() fetchFunction,
    T Function(Map<String, dynamic>)? fromJson,
    String? tag,
  }) async {
    final serviceTag = tag ?? "Service";

    return performanceService.measureAsync(operationName, () async {
      // Inisialisasi cache service jika belum

      try {
        // Coba ambil dari cache jika tidak dipaksa refresh
        if (!forceRefresh && cacheService.isValid(cacheKey)) {
          logger.d('Using cached data for $cacheKey', tag: serviceTag);
          final cachedData = cacheService.get(cacheKey);
          if (cachedData != null) {
            // Konversi dari JSON Map ke objek tipe T jika fromJson disediakan
            if (fromJson != null && cachedData is Map<String, dynamic>) {
              return fromJson(cachedData);
            }
            // Jika tidak ada fromJson, coba cast langsung (bisa gagal untuk tipe kompleks)
            return cachedData as T;
          }
        }

        // Jika tidak ada di cache atau dipaksa refresh, fetch data baru
        logger.d('Fetching fresh data for $cacheKey', tag: serviceTag);
        final freshData = await fetchFunction();

        // Simpan ke cache
        await cacheService.set(cacheKey, freshData, ttlMinutes: ttlMinutes);

        return freshData;
      } catch (e, stackTrace) {
        logger.e(
          'Error in cached operation for $cacheKey',
          error: e,
          stackTrace: stackTrace,
          tag: serviceTag,
        );
        rethrow;
      }
    }, tag: serviceTag);
  }

  /// Membersihkan cache untuk key tertentu
  Future<bool> clearCache(String cacheKey, {String? tag}) async {
    try {
      final result = await cacheService.remove(cacheKey);
      logger.d('Cleared cache for $cacheKey', tag: tag ?? "Service");
      return result;
    } catch (e) {
      logger.e(
        'Error clearing cache for $cacheKey',
        error: e,
        tag: tag ?? "Service",
      );
      return false;
    }
  }

  /// Membersihkan semua cache
  Future<bool> clearAllCache({String? tag}) async {
    try {
      final result = await cacheService.clearAll();
      logger.d('Cleared all cache', tag: tag ?? "Service");
      return result;
    } catch (e) {
      logger.e('Error clearing all cache', error: e, tag: tag ?? "Service");
      return false;
    }
  }

  /// Hapus semua cache yang sudah expired
  Future<int> cleanExpiredCache({String? tag}) async {
    try {
      final count = await cacheService.cleanExpiredCache();
      logger.d('Cleaned $count expired cache entries', tag: tag ?? "Service");
      return count;
    } catch (e) {
      logger.e('Error cleaning expired cache', error: e, tag: tag ?? "Service");
      return 0;
    }
  }

  /// Dapatkan statistik penggunaan cache
  Future<Map<String, dynamic>> getCacheStats({String? tag}) async {
    try {
      final stats = await cacheService.getCacheStats();
      logger.d('Cache stats: $stats', tag: tag ?? "Service");
      return stats;
    } catch (e) {
      logger.e('Error getting cache stats', error: e, tag: tag ?? "Service");
      return {
        'totalEntries': 0,
        'validEntries': 0,
        'expiredEntries': 0,
        'ttlEntries': 0,
      };
    }
  }
}
