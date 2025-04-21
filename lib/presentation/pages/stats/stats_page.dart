import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/pages/stats/widgets/stats_header_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_typografi.dart';
import '../../providers/stats/stats_provider.dart';
import 'widgets/activity_heatmap_widget.dart';
import 'widgets/tag_distribution_widget.dart';
import 'widgets/priority_completion_widget.dart';
import 'widgets/productivity_trends_widget.dart';
import 'widgets/achievements_widget.dart';
import 'widgets/date_range_selector_widget.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _StatsContent()));
  }
}

class _StatsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        // Use separate selectors for loading and error states
        final isLoading = ref.watch(
          statsProvider.select((state) => state.isLoading),
        );
        final error = ref.watch(statsProvider.select((state) => state.error));

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading statistics',
                  style: AppTypography.subtitle1.copyWith(
                    color: AppColors.errorColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.read(statsProvider.notifier).loadStats(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(statsProvider.notifier).loadStats(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatsHeaderWidget(),

                const ActivityHeatmapWidget(),
                const SizedBox(height: 24),

                // Tag Distribution
                const _SectionHeader(title: 'Task Distribution by Tag'),
                const TagDistributionWidget(),
                const SizedBox(height: 24),

                // Priority Completion Rate
                const _SectionHeader(title: 'Completion by Priority'),
                const PriorityCompletionWidget(),
                const SizedBox(height: 24),

                // Productivity Trends
                const _SectionHeader(title: 'Productivity Trends'),
                Consumer(
                  builder: (context, ref, _) {
                    final trendPeriod = ref.watch(
                      statsProvider.select((state) => state.trendPeriod),
                    );
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment<String>(
                              value: 'week',
                              label: Text('Weekly'),
                            ),
                            ButtonSegment<String>(
                              value: 'month',
                              label: Text('Monthly'),
                            ),
                          ],
                          selected: {trendPeriod},
                          onSelectionChanged: (value) {
                            ref
                                .read(statsProvider.notifier)
                                .setTrendPeriod(value.first);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                const ProductivityTrendsWidget(),
                const SizedBox(height: 24),

                // Achievements
                const _SectionHeader(title: 'Achievements'),
                const AchievementsWidget(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTypography.headline6.copyWith(
          color: AppColors.getTextPrimaryColor(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
