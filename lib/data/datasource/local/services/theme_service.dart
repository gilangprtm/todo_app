import 'package:flutter/material.dart';

import '../../../../core/base/base_network.dart';
import '../db/db_local.dart';

class ThemeService extends BaseService {
  final DBLocal _db;
  static const String themeKey = 'theme_mode';

  ThemeService({required DBLocal db}) : _db = db;

  /// Save theme mode to database
  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      await performanceAsync(
        operationName: 'save_theme_mode',
        function: () async {
          await _db.saveSetting(themeKey, _getStringFromThemeMode(mode));

          logger.d(
            'Theme mode saved: ${_getStringFromThemeMode(mode)}',
            tag: 'ThemeService',
          );
        },
        tag: 'ThemeService',
      );
    } catch (e, stackTrace) {
      logger.e(
        'Error saving theme mode',
        error: e,
        stackTrace: stackTrace,
        tag: 'ThemeService',
      );
      rethrow;
    }
  }

  /// Get current theme mode from database
  Future<ThemeMode> getCurrentThemeMode() async {
    try {
      return await performanceAsync(
        operationName: 'get_current_theme',
        function: () async {
          final savedTheme = await _db.getSetting(themeKey);
          return _getThemeModeFromString(savedTheme);
        },
        tag: 'ThemeService',
      );
    } catch (e, stackTrace) {
      logger.e(
        'Error getting current theme',
        error: e,
        stackTrace: stackTrace,
        tag: 'ThemeService',
      );
      return ThemeMode.light;
    }
  }

  /// Convert string to ThemeMode
  ThemeMode _getThemeModeFromString(String? theme) {
    switch (theme) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  /// Convert ThemeMode to string
  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }
}
