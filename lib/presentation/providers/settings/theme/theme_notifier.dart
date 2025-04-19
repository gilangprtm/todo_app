import 'package:flutter/material.dart';
import '../../../../core/base/base_state_notifier.dart';
import '../../../../data/datasource/local/services/theme_service.dart';
import 'theme_state.dart';

/// Notifier untuk mengelola tema aplikasi
class ThemeNotifier extends BaseStateNotifier<ThemeState> {
  final ThemeService _themeService;

  ThemeNotifier(super.initialState, super.ref, this._themeService);

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    await runAsync('toggleTheme', () async {
      try {
        final newTheme =
            state.themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;

        await _themeService.saveThemeMode(newTheme);
        state = state.copyWith(themeMode: newTheme, clearError: true);
      } catch (e, stackTrace) {
        logger.e('Error toggling theme', error: e, stackTrace: stackTrace);
        state = state.copyWith(error: e, stackTrace: stackTrace);
      }
    });
  }

  /// Set a specific theme mode
  Future<void> setTheme(ThemeMode mode) async {
    await runAsync('setTheme', () async {
      try {
        state = state.copyWith(themeMode: mode, clearError: true);
      } catch (e, stackTrace) {
        state = state.copyWith(error: e, stackTrace: stackTrace);
      }
    });
  }
}
