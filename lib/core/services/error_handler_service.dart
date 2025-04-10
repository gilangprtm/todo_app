import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'logger_service.dart';

/// Callback type untuk fungsi error reporting
typedef ErrorReportCallback = Future<void> Function(
    Object error, StackTrace stackTrace);

/// Callback type untuk fungsi error UI handling
typedef ErrorUICallback = Future<void> Function(
    BuildContext? context, Object error, StackTrace stackTrace);

/// Service untuk menangani error secara global
class ErrorHandlerService {
  // Singleton pattern
  static final ErrorHandlerService _instance = ErrorHandlerService._internal();
  static ErrorHandlerService get instance => _instance;
  ErrorHandlerService._internal();

  final LoggerService _logger = LoggerService.instance;

  /// Function untuk pelaporan error (akan diset sesuai layanan error reporting yang digunakan)
  ErrorReportCallback? _errorReportFunction;

  /// Konfigurasikan service error reporting
  void setErrorReportFunction(ErrorReportCallback reportFunction) {
    _errorReportFunction = reportFunction;
  }

  /// Konfigurasikan UI error handling
  void setErrorUIFunction(ErrorUICallback uiFunction) {}

  /// Inisialisasi global error handling
  void init() {
    // Set up global error catching
    FlutterError.onError = _handleFlutterError;

    // Set up zone-level error catching
    PlatformDispatcher.instance.onError = _handlePlatformError;
  }

  /// Menangani flutter error (widget errors, etc)
  void _handleFlutterError(FlutterErrorDetails details) {
    // Log error
    _logger.e(
      'Flutter Error: ${details.exception}',
      error: details.exception,
      stackTrace: details.stack,
      tag: 'FLUTTER_ERROR',
    );

    // Report error jika tersedia
    _reportError(details.exception, details.stack ?? StackTrace.current);
  }

  /// Menangani platform error (zone errors)
  bool _handlePlatformError(Object error, StackTrace stack) {
    // Log error
    _logger.e(
      'Uncaught Platform Error: $error',
      error: error,
      stackTrace: stack,
      tag: 'UNCAUGHT_ERROR',
    );

    // Report error jika tersedia
    _reportError(error, stack);

    // True berarti error telah ditangani dan tidak perlu diteruskan
    return true;
  }

  /// Menangani error pada fungsi async
  Future<void> handleAsyncError(Object error, StackTrace stackTrace,
      [BuildContext? context]) async {
    // Log error
    _logger.e(
      'Async Error: $error',
      error: error,
      stackTrace: stackTrace,
      tag: 'ASYNC_ERROR',
    );

    // Report error jika tersedia
    await _reportError(error, stackTrace);

    // Tampilkan UI jika tersedia
    if (context != null) {
      //await _showErrorUI(context, error, stackTrace);
    }
  }

  /// Internal method untuk melaporkan error
  Future<void> _reportError(Object error, StackTrace stackTrace) async {
    if (_errorReportFunction != null) {
      try {
        await _errorReportFunction!(error, stackTrace);
      } catch (e) {
        _logger.e(
          'Error reporting failed',
          error: e,
          tag: 'ERROR_HANDLER',
        );
      }
    }
  }

  /// Function wrapper untuk menangani error pada fungsi async
  Future<T> guardAsync<T>(Future<T> Function() function,
      [BuildContext? context]) async {
    try {
      return await function();
    } catch (error, stackTrace) {
      await handleAsyncError(error, stackTrace, context);
      rethrow;
    }
  }
}
