import '../../../core/base/base_state_notifier.dart';
import '../../../core/utils/mahas.dart';
import '../../../data/datasource/local/services/onboarding_service.dart';
import '../../../presentation/routes/app_routes.dart';
import 'onboarding_state.dart';

class OnboardingNotifier extends BaseStateNotifier<OnboardingState> {
  final OnboardingService _onboardingService;

  OnboardingNotifier(super.initialState, super.ref, this._onboardingService);

  @override
  Future<void> onInit() async {
    // Initialize any required data here
  }

  @override
  Future<void> onClose() async {
    // Clean up any resources here
  }

  Future<void> nextPage() async {
    if (state.currentPage < 2) {
      await runAsync('nextPage', () async {
        state = state.copyWith(
          currentPage: state.currentPage + 1,
          isLastPage: state.currentPage + 1 == 2,
        );
      });
    }
  }

  Future<void> previousPage() async {
    if (state.currentPage > 0) {
      await runAsync('previousPage', () async {
        state = state.copyWith(
          currentPage: state.currentPage - 1,
          isLastPage: false,
        );
      });
    }
  }

  Future<void> skipToLast() async {
    await runAsync('skipToLast', () async {
      state = state.copyWith(currentPage: 2, isLastPage: true);
    });
  }

  Future<void> initializeDatabase() async {
    try {
      await runAsync('initializeDatabase', () async {
        state = state.copyWith(isLoading: true);

        // Initialize database and settings
        await _onboardingService.initializeDatabase();

        // Navigate to home
        Mahas.routeToAndRemove(AppRoutes.home);
      });
    } catch (e, stackTrace) {
      logger.e(
        'Error initializing database',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnboardingNotifier',
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize database',
      );
      Mahas.snackbar(
        'Error',
        'Failed to initialize database. Please try again.',
      );
    }
  }
}
