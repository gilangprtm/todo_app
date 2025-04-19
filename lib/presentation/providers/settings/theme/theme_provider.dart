import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/service_providers.dart';
import 'theme_notifier.dart';
import 'theme_state.dart';

/// Provider untuk tema aplikasi
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return ThemeNotifier(ThemeState(), ref, themeService);
});
