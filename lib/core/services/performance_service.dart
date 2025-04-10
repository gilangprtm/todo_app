import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'logger_service.dart';

/// Service untuk monitoring dan mengoptimasi performa aplikasi
class PerformanceService {
  // Singleton pattern
  static final PerformanceService _instance = PerformanceService._internal();
  static PerformanceService get instance => _instance;

  final LoggerService _logger = LoggerService.instance;

  // Data untuk performance tracking
  final Map<String, _PerformanceMetric> _metrics = {};
  final Queue<Map<String, dynamic>> _performanceHistory = Queue();

  // Konfigurasi
  final int _maxHistorySize = 100;
  late final bool _trackPerformance;

  // Constructor
  PerformanceService._internal() {
    _trackPerformance = kDebugMode;
  }

  /// Memulai pengukuran waktu eksekusi suatu fungsi/operasi
  Stopwatch startMeasurement(String operationName) {
    if (!_trackPerformance) return Stopwatch();

    final stopwatch = Stopwatch()..start();
    return stopwatch;
  }

  /// Menyelesaikan pengukuran dan mencatat hasilnya
  void endMeasurement(String operationName, Stopwatch stopwatch,
      {String? tag}) {
    if (!_trackPerformance) return;

    stopwatch.stop();
    final executionTime = stopwatch.elapsedMilliseconds;

    // Catat ke metrics
    if (!_metrics.containsKey(operationName)) {
      _metrics[operationName] = _PerformanceMetric(operationName);
    }

    _metrics[operationName]!.addExecution(executionTime);

    // Catat history
    final entry = {
      'operation': operationName,
      'executionTime': executionTime,
      'timestamp': DateTime.now().toIso8601String(),
      'tag': tag ?? 'PERFORMANCE',
    };

    _performanceHistory.add(entry);
    while (_performanceHistory.length > _maxHistorySize) {
      _performanceHistory.removeFirst();
    }

    // Log execution time
    if (executionTime > 1000) {
      _logger.w('⏱️ Slow operation: $operationName took ${executionTime}ms',
          tag: tag ?? 'PERFORMANCE');
    } else {
      _logger.d('⏱️ Operation: $operationName took ${executionTime}ms',
          tag: tag ?? 'PERFORMANCE');
    }
  }

  /// Wrapper untuk mengukur waktu eksekusi fungsi
  Future<T> measureAsync<T>(String operationName, Future<T> Function() function,
      {String? tag}) async {
    if (!_trackPerformance) return function();

    final stopwatch = startMeasurement(operationName);
    try {
      return await function();
    } finally {
      endMeasurement(operationName, stopwatch, tag: tag);
    }
  }

  /// Wrapper untuk mengukur waktu eksekusi fungsi
  T measure<T>(String operationName, T Function() function, {String? tag}) {
    if (!_trackPerformance) return function();

    final stopwatch = startMeasurement(operationName);
    try {
      return function();
    } finally {
      endMeasurement(operationName, stopwatch, tag: tag);
    }
  }

  /// Mendapatkan ringkasan performa aplikasi
  Map<String, Map<String, dynamic>> getPerformanceSummary() {
    final Map<String, Map<String, dynamic>> summary = {};

    for (final entry in _metrics.entries) {
      final metric = entry.value;
      summary[entry.key] = {
        'avgExecutionTime': metric.averageExecutionTime,
        'minExecutionTime': metric.minExecutionTime,
        'maxExecutionTime': metric.maxExecutionTime,
        'lastExecutionTime': metric.lastExecutionTime,
        'count': metric.executionCount,
      };
    }

    return summary;
  }

  /// Mendapatkan log history performa
  List<Map<String, dynamic>> getPerformanceHistory() {
    return _performanceHistory.toList();
  }

  /// Membersihkan history performa
  void clearPerformanceHistory() {
    _performanceHistory.clear();
    _logger.i('Performance history cleared', tag: 'PERFORMANCE');
  }

  /// Reset performance metrics
  void resetMetrics() {
    _metrics.clear();
    _logger.i('Performance metrics reset', tag: 'PERFORMANCE');
  }
}

/// Class untuk menyimpan metrik performa suatu operasi
class _PerformanceMetric {
  final String operationName;
  int executionCount = 0;
  int totalExecutionTime = 0;
  int minExecutionTime = 0;
  int maxExecutionTime = 0;
  int lastExecutionTime = 0;

  _PerformanceMetric(this.operationName);

  void addExecution(int executionTime) {
    executionCount++;
    totalExecutionTime += executionTime;
    lastExecutionTime = executionTime;

    if (executionCount == 1) {
      minExecutionTime = executionTime;
      maxExecutionTime = executionTime;
    } else {
      minExecutionTime =
          executionTime < minExecutionTime ? executionTime : minExecutionTime;
      maxExecutionTime =
          executionTime > maxExecutionTime ? executionTime : maxExecutionTime;
    }
  }

  double get averageExecutionTime =>
      executionCount > 0 ? totalExecutionTime / executionCount : 0;
}
