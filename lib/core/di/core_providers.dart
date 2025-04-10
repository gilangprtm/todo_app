// lib/core/di/core_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/error_handler_service.dart';
import '../services/logger_service.dart';
import '../services/performance_service.dart';
import '../services/initial_route_service.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../services/cache_service.dart';

// Logger dan Error Handler (singleton)
final loggerServiceProvider = Provider<LoggerService>((ref) {
  return LoggerService.instance;
});

final errorHandlerServiceProvider = Provider<ErrorHandlerService>((ref) {
  return ErrorHandlerService.instance;
});

// Performance Service (singleton)
final performanceServiceProvider = Provider<PerformanceService>((ref) {
  return PerformanceService.instance;
});

// Initial Route Service (singleton)
final initialRouteServiceProvider = Provider<InitialRouteService>((ref) {
  return InitialRouteService();
});

// Firebase Service (lazy singleton)
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

// Storage Service (lazy singleton)
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});

// Cache Service (singleton)
final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService.instance;
});
