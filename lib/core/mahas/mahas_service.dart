import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/settings/theme/theme_provider.dart';
import '../../presentation/routes/app_routes.dart';
import '../di/service_providers.dart';
import '../services/logger_service.dart';
import '../services/error_handler_service.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../services/cache_service.dart';
import '../../data/datasource/local/db/db_local.dart';

/// MahasService adalah kelas singleton yang mengelola inisialisasi aplikasi
/// seperti firebase, local storage, dll.
class MahasService {
  static final MahasService _instance = MahasService._internal();
  static MahasService get instance => _instance;

  // Private constructor
  MahasService._internal();

  /// Inisialisasi seluruh layanan yang dibutuhkan sebelum aplikasi dijalankan
  static Future<void> init() async {
    try {
      // Inisialisasi Logger terlebih dahulu untuk bisa mencatat progress inisialisasi lainnya
      final logger = LoggerService.instance;

      // Inisialisasi error handler
      await initErrorHandler();

      // Inisialisasi Cache Service
      //await initCache();

      // Inisialisasi Firebase (jika diperlukan)
      //await initFirebase();

      // Inisialisasi Local Storage (jika diperlukan)
      //await initStorage();

      logger.i('✅ All services initialized successfully!', tag: 'MAHAS');
    } catch (e, stackTrace) {
      LoggerService.instance.e(
        '❌ Error initializing application services',
        error: e,
        stackTrace: stackTrace,
        tag: 'MAHAS',
      );
      rethrow;
    }
  }

  /// Determine the initial route based on application state
  static Future<String> determineInitialRoute() async {
    try {
      // Initialize database
      final db = DBLocal();

      // Check if first_run is set to false in settings
      final firstRunSetting = await db.getSetting('first_run');
      if (firstRunSetting == 'false') {
        return AppRoutes.home;
      }

      // Check if we have any data in the todo table
      final hasData = await db.hasData(DBLocal.tableTodo);
      if (hasData) {
        return AppRoutes.home;
      }

      // If no settings or no todo data exists, user needs to go through onboarding
      return AppRoutes.onboarding;
    } catch (e, stackTrace) {
      LoggerService.instance.e(
        '❌ Error determining initial route',
        error: e,
        stackTrace: stackTrace,
        tag: 'MAHAS',
      );
      // Return onboarding as fallback to ensure proper initialization
      return AppRoutes.onboarding;
    }
  }

  /// Inisialisasi theme menggunakan container yang diberikan dari main
  /// untuk memastikan theme diinisialisasi dengan benar sebelum aplikasi dimulai
  static Future<void> initThemeWithContainer(
    ProviderContainer container,
  ) async {
    try {
      // Gunakan container yang sama yang akan digunakan oleh app
      final themeService = container.read(themeServiceProvider);
      final themeNotifier = container.read(themeProvider.notifier);

      // Ambil tema dari database
      final currentTheme = await themeService.getCurrentThemeMode();

      // Set ke theme notifier
      await themeNotifier.setTheme(currentTheme);
    } catch (e, stackTrace) {
      LoggerService.instance.e(
        '❌ Error initializing theme',
        error: e,
        stackTrace: stackTrace,
        tag: 'MAHAS',
      );
      // Tidak throw exception agar aplikasi tetap bisa berjalan dengan tema default
    }
  }

  /// Inisialisasi Error Handler
  static Future<void> initErrorHandler() async {
    try {
      final errorHandler = ErrorHandlerService.instance;
      errorHandler.init();
      LoggerService.instance.i(
        '✅ Error Handler initialized successfully',
        tag: 'MAHAS',
      );
    } catch (e, stackTrace) {
      LoggerService.instance.e(
        '❌ Error initializing Error Handler',
        error: e,
        stackTrace: stackTrace,
        tag: 'MAHAS',
      );
      rethrow;
    }
  }

  /// Inisialisasi Cache Service
  static Future<void> initCache() async {
    try {
      await CacheService.instance.initialize();

      // Cache service sudah di-refactor sehingga preemptive cleaning
      // berjalan otomatis sebagian dari initialize()
      // Lihat implementasi di CacheService

      LoggerService.instance.i(
        '✅ Cache Service initialized successfully',
        tag: 'MAHAS',
      );
    } catch (e, stackTrace) {
      LoggerService.instance.e(
        '❌ Error initializing Cache Service',
        error: e,
        stackTrace: stackTrace,
        tag: 'MAHAS',
      );
      rethrow;
    }
  }

  /// Inisialisasi Firebase
  static Future<void> initFirebase() async {
    try {
      await FirebaseService.instance.init();
      LoggerService.instance.i(
        '✅ Firebase initialized successfully',
        tag: 'MAHAS',
      );
    } catch (e, stackTrace) {
      LoggerService.instance.e(
        '❌ Error initializing Firebase',
        error: e,
        stackTrace: stackTrace,
        tag: 'MAHAS',
      );
      rethrow;
    }
  }

  /// Inisialisasi Storage
  static Future<void> initStorage() async {
    try {
      await StorageService.instance.init();
      LoggerService.instance.i(
        '✅ Storage initialized successfully',
        tag: 'MAHAS',
      );
    } catch (e, stackTrace) {
      LoggerService.instance.e(
        '❌ Error initializing Storage',
        error: e,
        stackTrace: stackTrace,
        tag: 'MAHAS',
      );
      rethrow;
    }
  }
}
