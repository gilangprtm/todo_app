import '../../../core/base/base_state_notifier.dart';

class OnboardingState extends BaseState {
  final int currentPage;
  final bool isLastPage;

  const OnboardingState({
    super.isLoading = false,
    super.error,
    super.stackTrace,
    this.currentPage = 0,
    this.isLastPage = false,
  });

  @override
  OnboardingState copyWith({
    bool? isLoading,
    Object? error,
    StackTrace? stackTrace,
    bool clearError = false,
    int? currentPage,
    bool? isLastPage,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}
