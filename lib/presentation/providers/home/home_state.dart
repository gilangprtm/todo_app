import '../../../core/base/base_state_notifier.dart';

/// State class for the Home Screen
class HomeState extends BaseState {
  const HomeState({
    super.isLoading = false,
    super.error,
    super.stackTrace,
  });

  @override
  HomeState copyWith({
    bool? isLoading,
    Object? error,
    StackTrace? stackTrace,
    bool clearError = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
    );
  }
}
