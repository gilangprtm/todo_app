import '../../../core/base/base_state_notifier.dart';
import 'home_state.dart';

/// StateNotifier for the Home Screen
class HomeNotifier extends BaseStateNotifier<HomeState> {
  HomeNotifier(super.initialState, super.ref);

  // Currently empty as the original HomeProvider doesn't have any functionality
  // We can add methods here as needed in the future
}
