import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/error_handler_service.dart';
import '../services/logger_service.dart';

/// A base state class for Riverpod StateNotifier implementations
/// Can be extended for specific feature states
class BaseState {
  /// Indicates whether the state is in a loading condition
  final bool isLoading;

  /// Holds error information if there is an error
  final Object? error;

  /// Stack trace for error debugging
  final StackTrace? stackTrace;

  const BaseState({this.isLoading = false, this.error, this.stackTrace});

  /// Creates a copy of this state with the given fields replaced
  BaseState copyWith({
    bool? isLoading,
    Object? error,
    StackTrace? stackTrace,
    bool clearError = false,
  }) {
    return BaseState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
    );
  }
}

/// A base class for all state notifiers in the application that extends [StateNotifier].
///
/// This class provides lifecycle methods similar to BaseProvider but adapted for Riverpod.
/// It also provides error handling and logging functionality.
abstract class BaseStateNotifier<T extends BaseState> extends StateNotifier<T> {
  /// Reference to the ProviderContainer, used to access other providers
  final Ref _ref;

  /// BuildContext if available, can be null
  BuildContext? _context;

  // Core services made available to all providers
  final LoggerService _logger = LoggerService.instance;
  final ErrorHandlerService _errorHandler = ErrorHandlerService.instance;

  // Expose services to subclasses
  LoggerService get logger => _logger;
  ErrorHandlerService get errorHandler => _errorHandler;

  /// Access to the Ref for dependency injection
  Ref get ref => _ref;

  /// Returns the current [BuildContext] associated with this notifier.
  BuildContext? get context => _context;

  /// Gets the tag for logging, uses the class name by default.
  /// Subclasses can override this to provide a custom tag.
  String get logTag => runtimeType.toString();

  BaseStateNotifier(super.initialState, this._ref) {
    onInit();
    // onReady will be called explicitly after widget initialization
  }

  /// Sets the [BuildContext] associated with this notifier.
  ///
  /// This allows for context-based operations such as navigation or displaying dialogs.
  void setContext(BuildContext context) {
    _context = context;
  }

  /// Called when the notifier is first created.
  ///
  /// Use this method to initialize state or setup listeners.
  void onInit() {
    _logger.i('onInit called', tag: logTag);
    // To be overridden by subclasses
  }

  /// Called after [onInit] and when the widget is ready.
  ///
  /// Use this method to perform tasks that should happen after the UI is built,
  /// such as fetching initial data.
  void onReady() {
    _logger.i('onReady called', tag: logTag);
    // To be overridden by subclasses
  }

  // Add a flag to track if the notifier is being disposed
  bool _isDisposing = false;
  bool get isDisposing => _isDisposing;

  /// Called when the notifier is about to be disposed.
  ///
  /// Use this method to clean up resources such as listeners or subscriptions.
  @override
  void dispose() {
    _isDisposing = true;
    onClose();
    super.dispose();
  }

  /// Called before [dispose] to allow cleanup.
  ///
  /// This method is separated from [dispose] to allow subclasses to perform
  /// custom cleanup without needing to call super.dispose().
  void onClose() {
    _logger.i('onClose called - cleaning up resources', tag: logTag);
    // To be overridden by subclasses
  }

  /// Sets the loading state
  void setLoading(bool isLoading) {
    // Check if the notifier is still mounted before updating state
    if (!mounted) {
      logger.w('Attempted to set loading state after disposal', tag: logTag);
      return;
    }

    state =
        state.copyWith(
              isLoading: isLoading,
              clearError: isLoading, // Clear errors when starting new loading
            )
            as T;
  }

  /// Sets an error state
  void setError(Object error, StackTrace stackTrace) {
    // Check if the notifier is still mounted before updating state
    if (!mounted) {
      logger.w('Attempted to set error state after disposal', tag: logTag);
      return;
    }

    state =
        state.copyWith(isLoading: false, error: error, stackTrace: stackTrace)
            as T;
  }

  /// Clears any error state
  void clearError() {
    // Check if the notifier is still mounted before updating state
    if (!mounted) {
      logger.w('Attempted to clear error state after disposal', tag: logTag);
      return;
    }

    state = state.copyWith(clearError: true) as T;
  }

  /// Helper method for handling synchronous operations with error handling
  void run(String operationName, void Function() action) {
    _logger.d('Starting operation: $operationName', tag: logTag);

    try {
      action();
      _logger.d('Completed operation: $operationName', tag: logTag);
    } catch (e, stackTrace) {
      _logger.e(
        'Error in $operationName',
        error: e,
        stackTrace: stackTrace,
        tag: logTag,
      );

      if (context != null) {
        _errorHandler.handleAsyncError(e, stackTrace, context);
      }

      setError(e, stackTrace);
      rethrow;
    }
  }

  /// Helper method for handling synchronous operations with return value and error handling
  T2 runWithResult<T2>(String operationName, T2 Function() action) {
    _logger.d('Starting operation: $operationName', tag: logTag);

    try {
      final result = action();
      _logger.d('Completed operation: $operationName', tag: logTag);
      return result;
    } catch (e, stackTrace) {
      _logger.e(
        'Error in $operationName',
        error: e,
        stackTrace: stackTrace,
        tag: logTag,
      );

      if (context != null) {
        _errorHandler.handleAsyncError(e, stackTrace, context);
      }

      setError(e, stackTrace);
      rethrow;
    }
  }

  /// Helper method for handling asynchronous operations with error handling
  Future<void> runAsync(
    String operationName,
    Future<void> Function() action,
  ) async {
    _logger.d('Starting async operation: $operationName', tag: logTag);

    try {
      // Run the action but check mounted status afterward
      await action();

      if (!mounted) {
        _logger.w(
          'Operation $operationName completed after disposal',
          tag: logTag,
        );
        return;
      }

      _logger.d('Completed async operation: $operationName', tag: logTag);
    } catch (e, stackTrace) {
      if (!mounted) {
        _logger.w('Error in $operationName after disposal: $e', tag: logTag);
        return;
      }

      _logger.e(
        'Error in async $operationName',
        error: e,
        stackTrace: stackTrace,
        tag: logTag,
      );

      if (context != null) {
        await _errorHandler.handleAsyncError(e, stackTrace, context);
      }

      setError(e, stackTrace);
      rethrow;
    }
  }

  /// Helper method for handling asynchronous operations with return value and error handling
  Future<T2> runAsyncWithResult<T2>(
    String operationName,
    Future<T2> Function() action,
  ) async {
    _logger.d('Starting async operation: $operationName', tag: logTag);

    try {
      final result = await action();

      if (!mounted) {
        _logger.w(
          'Operation $operationName completed after disposal',
          tag: logTag,
        );
        return result;
      }

      _logger.d('Completed async operation: $operationName', tag: logTag);
      return result;
    } catch (e, stackTrace) {
      if (!mounted) {
        _logger.w('Error in $operationName after disposal: $e', tag: logTag);
        rethrow;
      }

      _logger.e(
        'Error in async $operationName',
        error: e,
        stackTrace: stackTrace,
        tag: logTag,
      );

      if (context != null) {
        await _errorHandler.handleAsyncError(e, stackTrace, context);
      }

      setError(e, stackTrace);
      rethrow;
    }
  }
}

/// Extension to provide additional helper methods for working with Riverpod
extension AsyncValueX<T> on AsyncValue<T> {
  /// Helper to handle AsyncValue states with a single builder
  R whenOrElse<R>({
    required R Function(T data) data,
    required R Function(Object error, StackTrace stackTrace) error,
    required R Function() loading,
  }) {
    return when(data: data, error: error, loading: loading);
  }
}
