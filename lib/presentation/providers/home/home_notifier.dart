import '../../../core/base/base_state_notifier.dart';
import 'home_state.dart';

/// StateNotifier for the Home Screen
class HomeNotifier extends BaseStateNotifier<HomeState> {
  HomeNotifier(super.initialState, super.ref);

  /// Changes the selected menu index
  void changeMenu(int index) {
    logger.d('Changing menu index to $index', tag: 'HomeNotifier');
    state = state.copyWith(selectedMenuIndex: index);
  }

  @override
  Future<void> onInit() async {
    logger.d('HomeNotifier initialized', tag: 'HomeNotifier');
  }
}
