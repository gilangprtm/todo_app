import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_providers.dart';
import 'onboarding_notifier.dart';
import 'onboarding_state.dart';

final onboardingProvider =
    StateNotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>((
      ref,
    ) {
      final onboardingService = ref.watch(onboardingServiceProvider);

      // Create the initial state
      const initialState = OnboardingState();

      // Create and return the notifier with initial state and services
      return OnboardingNotifier(initialState, ref, onboardingService);
    });
