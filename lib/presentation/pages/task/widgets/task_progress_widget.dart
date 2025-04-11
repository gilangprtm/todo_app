import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typografi.dart';
import '../../../../core/mahas/widget/mahas_card.dart';
import '../../../providers/task/task_provider.dart';

class TaskProgressWidget extends StatelessWidget {
  final double? completionPercentage;
  final String? completionString;
  final int? taskCount;
  final int? completedCount;
  final bool? filterByToday;

  const TaskProgressWidget({
    super.key,
    this.completionPercentage,
    this.completionString,
    this.taskCount,
    this.completedCount,
    this.filterByToday,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(taskProvider);
        final notifier = ref.read(taskProvider.notifier);

        // Use provided values or fallback to the ones from state
        final percentage = completionPercentage ?? state.completionPercentage;
        final percentageString =
            completionString ?? state.completionPercentageString;
        final taskCountValue = taskCount ?? state.todos.length;
        final completedCountValue = completedCount ?? state.completedCount;
        final isFilterByToday = filterByToday ?? state.filterByToday;

        return MahasCustomizableCard(
          color: AppColors.getCardColor(context),
          padding: 16.0,
          margin: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Task Hari Ini",
                    style: AppTypography.subtitle1.copyWith(
                      color: AppColors.getTextPrimaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => notifier.toggleTodayFilter(),
                    child: Row(
                      children: [
                        Icon(
                          isFilterByToday
                              ? Icons.calendar_today
                              : Icons.calendar_view_month,
                          size: 16,
                          color: AppColors.getTextSecondaryColor(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isFilterByToday ? "Hari Ini" : "Semua Task",
                          style: AppTypography.caption.copyWith(
                            color: AppColors.getTextSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$taskCountValue Task",
                          style: AppTypography.headline6.copyWith(
                            color: AppColors.getTextPrimaryColor(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$completedCountValue Selesai",
                          style: AppTypography.bodyText2.copyWith(
                            color: AppColors.getTextSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: AppColors.getProgressBackgroundColor(
                            context,
                          ),
                          color: AppColors.getProgressForegroundColor(context),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          percentageString,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.getTextSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
