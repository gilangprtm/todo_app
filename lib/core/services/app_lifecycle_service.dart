import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/home/home_provider.dart';
import '../../presentation/providers/task/task_provider.dart';
import '../../presentation/providers/calendar/calendar_provider.dart';

/// Service untuk menangani app lifecycle events
/// Melakukan refresh data saat aplikasi kembali dari background
class AppLifecycleService with WidgetsBindingObserver {
  final Ref _ref;
  DateTime? _lastPausedTime;

  // Minimal waktu di background untuk refresh (10 detik)
  static const minBackgroundTime = Duration(seconds: 10);

  AppLifecycleService(this._ref) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastPausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed && _lastPausedTime != null) {
      final timeInBackground = DateTime.now().difference(_lastPausedTime!);

      // Jika cukup lama di background, refresh
      if (timeInBackground > minBackgroundTime) {
        final currentTabIndex = _ref.read(homeProvider).selectedMenuIndex;
        _silentRefreshCurrentTab(currentTabIndex);
      }
    }
  }

  void _silentRefreshCurrentTab(int tabIndex) {
    switch (tabIndex) {
      case 0: // Task page
        _ref.read(taskProvider.notifier).silentRefresh();
        break;
      case 1: // Calendar page
        _ref.read(calendarProvider.notifier).silentRefresh();
        break;
      // Handle tab lain jika ada
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

// Provider untuk AppLifecycleService
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  final service = AppLifecycleService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});
