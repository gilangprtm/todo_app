import 'package:flutter/material.dart';
import '../../../../core/base/base_state_notifier.dart';

/// State untuk tema aplikasi
class ThemeState extends BaseState {
  final ThemeMode themeMode;

  ThemeState({
    super.isLoading = false,
    super.error,
    super.stackTrace,
    this.themeMode = ThemeMode.light,
  });

  @override
  ThemeState copyWith({
    bool? isLoading,
    dynamic error,
    StackTrace? stackTrace,
    bool clearError = false,
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
