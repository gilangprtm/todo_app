import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/mahas/widget/mahas_tab.dart';
import '../../../core/theme/app_color.dart';
import '../../providers/task/task_provider.dart';
import 'widgets/task_header_widget.dart';
import 'widgets/task_progress_widget.dart';
import 'widgets/today_tasks_tab.dart';
import 'widgets/previous_tasks_tab.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date, greeting and avatar - static part, no need for Consumer
              const TaskHeaderWidget(),

              const SizedBox(height: 24),

              // Only rebuild TaskProgressWidget when relevant data changes
              Consumer(
                builder: (context, ref, _) {
                  // Select only the specific parts of state needed for this widget
                  final completionPercentage = ref.watch(
                    taskProvider.select((state) => state.completionPercentage),
                  );
                  final completionString = ref.watch(
                    taskProvider.select(
                      (state) => state.completionPercentageString,
                    ),
                  );
                  final todos = ref.watch(
                    taskProvider.select((state) => state.todos.length),
                  );
                  final completedCount = ref.watch(
                    taskProvider.select((state) => state.completedCount),
                  );
                  final filterByToday = ref.watch(
                    taskProvider.select((state) => state.filterByToday),
                  );

                  return TaskProgressWidget(
                    completionPercentage: completionPercentage,
                    completionString: completionString,
                    taskCount: todos,
                    completedCount: completedCount,
                    filterByToday: filterByToday,
                  );
                },
              ),

              const SizedBox(height: 10),

              // Tab bar section
              Expanded(
                child: MahasPillTabBar(
                  tabLabels: const ['Hari Ini', 'Sebelumnya'],
                  tabViews: const [
                    // Today's tasks tab - using ConsumerWidget for efficient rebuilds
                    TodayTasksTab(),

                    // Previous tasks tab - using ConsumerWidget for efficient rebuilds
                    PreviousTasksTab(),
                  ],
                  activeColor: AppColors.getTextPrimaryColor(context),
                  backgroundColor: Colors.grey[200]!,
                  activeTextColor: AppColors.getCardColor(context),
                  inactiveTextColor: AppColors.getTextSecondaryColor(context),
                  height: 45,
                  borderRadius: 15,
                  padding: const EdgeInsets.all(4.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
