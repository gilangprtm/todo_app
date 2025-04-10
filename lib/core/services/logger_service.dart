import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Level log yang didukung
enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

/// Service untuk mengelola logging aplikasi
class LoggerService {
  // Singleton pattern
  static final LoggerService _instance = LoggerService._internal();
  static LoggerService get instance => _instance;
  LoggerService._internal();

  // Current log level, log dengan level di bawah ini tidak akan ditampilkan
  LogLevel _currentLogLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  // History logs untuk keperluan debugging
  final List<Map<String, dynamic>> _logHistory = [];

  /// Mendapatkan history logs
  List<Map<String, dynamic>> get logHistory => _logHistory;

  /// Mengatur level log
  void setLogLevel(LogLevel level) {
    _currentLogLevel = level;
  }

  /// Log debug message
  void d(String message, {Object? data, String? tag, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, data: data, tag: tag, stackTrace: stackTrace);
  }

  /// Log info message
  void i(String message, {Object? data, String? tag, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, data: data, tag: tag, stackTrace: stackTrace);
  }

  /// Log warning message
  void w(String message, {Object? data, String? tag, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message,
        data: data, tag: tag, stackTrace: stackTrace);
  }

  /// Log error message
  void e(String message, {Object? error, String? tag, StackTrace? stackTrace}) {
    _log(LogLevel.error, message,
        data: error, tag: tag, stackTrace: stackTrace);
  }

  /// Log fatal error message
  void f(String message, {Object? error, String? tag, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message,
        data: error, tag: tag, stackTrace: stackTrace);
  }

  /// Method internal untuk melakukan logging berdasarkan level
  void _log(
    LogLevel level,
    String message, {
    Object? data,
    String? tag,
    StackTrace? stackTrace,
  }) {
    // Skip jika level di bawah current level
    if (level.index < _currentLogLevel.index) {
      return;
    }

    final String logTag = tag ?? 'APP';
    final DateTime now = DateTime.now();

    // Emoji untuk masing-masing level
    _getEmojiForLevel(level);

    // Log ke console dalam mode debug
    if (kDebugMode) {
      // Gunakan warna berbeda untuk level berbeda
      developer.log(
        message,
        name: logTag,
        time: now,
        level: level.index * 100,
        error: data is Exception || data is Error ? data : null,
        stackTrace: stackTrace,
      );
    }
  }

  /// Mendapatkan emoji berdasarkan level log
  String _getEmojiForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.fatal:
        return '💥';
    }
  }

  /// Membersihkan history log
  void clearHistory() {
    _logHistory.clear();
  }

  /// Ekspor log history ke string
  String exportLogs() {
    return const JsonEncoder.withIndent('  ').convert(_logHistory);
  }
}
