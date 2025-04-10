import 'package:flutter/material.dart';
import '../../../core/base/base_state_notifier.dart';

class OnboardingState extends BaseState {
  final int currentPage;
  final bool isLastPage;
  final PageController pageController;
  final bool ignorePageChange;

  const OnboardingState({
    super.isLoading = false,
    super.error,
    super.stackTrace,
    this.currentPage = 0,
    this.isLastPage = false,
    required this.pageController,
    this.ignorePageChange = false,
  });

  @override
  OnboardingState copyWith({
    bool? isLoading,
    Object? error,
    StackTrace? stackTrace,
    bool clearError = false,
    int? currentPage,
    bool? isLastPage,
    PageController? pageController,
    bool? ignorePageChange,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
      pageController: pageController ?? this.pageController,
      ignorePageChange: ignorePageChange ?? this.ignorePageChange,
    );
  }
}
