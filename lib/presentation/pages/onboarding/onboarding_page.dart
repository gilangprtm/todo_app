import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/mahas/mahas_type.dart';
import '../../../core/mahas/widget/mahas_button.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_typografi.dart';
import '../../providers/onboarding/onboarding_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;
  bool _ignorePageChange = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Listen to page changes to update the controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(onboardingProvider);
      _pageController.jumpToPage(state.currentPage);

      ref.listenManual(
        onboardingProvider.select((state) => state.currentPage),
        (previous, next) {
          if (previous != next && _pageController.hasClients) {
            _ignorePageChange = true;
            _pageController
                .animateToPage(
                  next,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                )
                .then((_) {
                  _ignorePageChange = false;
                });
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final pages = [
      _buildPage(
        context,
        'assets/images/onboarding_1.svg',
        'Organize Your Tasks',
        'Keep track of your daily tasks and stay organized with our simple and intuitive interface.',
      ),
      _buildPage(
        context,
        'assets/images/onboarding_2.svg',
        'Set Priorities',
        'Prioritize your tasks and focus on what matters most with our priority system.',
      ),
      _buildPage(
        context,
        'assets/images/onboarding_3.svg',
        'Get Started',
        'Start organizing your tasks today and boost your productivity.',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.ghibliCream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: pages.length,
                controller: _pageController,
                onPageChanged: (index) {
                  if (_ignorePageChange) return;

                  if (index < state.currentPage) {
                    notifier.previousPage();
                  } else if (index > state.currentPage) {
                    notifier.nextPage();
                  }
                },
                itemBuilder: (context, index) => pages[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              index == state.currentPage
                                  ? AppColors.notionBlack
                                  : AppColors.notionBlack.withValues(
                                    alpha: 0.3,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  MahasButton(
                    onPressed: () {
                      if (state.isLastPage) {
                        notifier.initializeDatabase();
                      } else {
                        notifier.nextPage();
                      }
                    },
                    color: AppColors.notionBlack,
                    isFullWidth: true,
                    text: state.isLastPage ? 'Get Started' : 'Next',
                    isLoading: state.isLoading,
                  ),
                  if (!state.isLastPage) ...[
                    const SizedBox(height: 8),
                    MahasButton(
                      onPressed: () => notifier.skipToLast(),
                      text: 'Skip',
                      type: ButtonType.text,
                      isFullWidth: true,
                      textColor: AppColors.notionBlack,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
    BuildContext context,
    String imagePath,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SvgPicture.asset(
              imagePath,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: AppTypography.headline5.copyWith(
              color: AppColors.notionBlack,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: AppTypography.bodyText1.copyWith(
              color: AppColors.notionBlack.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
