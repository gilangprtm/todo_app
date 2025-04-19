import '../../../core/base/base_state_notifier.dart';
import '../../../core/services/refresh_coordination_service.dart';
import '../task/task_provider.dart';
import '../calendar/calendar_provider.dart';
import 'home_state.dart';

/// StateNotifier for the Home Screen
class HomeNotifier extends BaseStateNotifier<HomeState> {
  // Refresh service untuk koordinasi refresh
  final _refreshService = RefreshCoordinationService();

  HomeNotifier(super.initialState, super.ref);

  /// Changes the selected menu index dan melakukan silent refresh pada tab yang baru
  void changeMenu(int index) {
    // Jika tab sama, tidak perlu melakukan apa-apa
    if (state.selectedMenuIndex == index) return;

    logger.d('Changing menu index to $index', tag: 'HomeNotifier');

    // Simpan tab sebelumnya

    // Update state dengan index menu baru
    state = state.copyWith(selectedMenuIndex: index);

    // Lakukan silent refresh pada tab yang baru dibuka
    _silentRefreshTab(index);
  }

  /// Melakukan silent refresh pada tab yang diberikan
  void _silentRefreshTab(int tabIndex) {
    // Jika tidak perlu refresh berdasarkan interval waktu, skip
    final tabKey = 'tab_$tabIndex';
    if (!_refreshService.shouldRefresh(tabKey)) {
      logger.d(
        'Skipping refresh for tab $tabIndex - recently refreshed',
        tag: 'HomeNotifier',
      );
      return;
    }

    // Lakukan silent refresh berdasarkan tab
    switch (tabIndex) {
      case 0: // Task page
        ref.read(taskProvider.notifier).silentRefresh();
        break;
      case 1: // Calendar page
        ref.read(calendarProvider.notifier).silentRefresh();
        break;
      // Tambahkan case untuk tab lain jika ada
    }

    // Catat waktu refresh
    _refreshService.markRefreshed(tabKey);
  }

  /// Memaksa refresh pada tab yang aktif saat ini
  void refreshCurrentTab() {
    _silentRefreshTab(state.selectedMenuIndex);
  }
}
