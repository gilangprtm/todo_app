import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_color.dart';
import '../../../providers/calendar/calendar_provider.dart';

class CalendarTableWidget extends ConsumerWidget {
  const CalendarTableWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);
    final focusedDay = calendarState.focusedDay;
    final selectedDay = calendarState.selectedDay;
    final eventMarkers = calendarState.eventMarkers;
    final isLoadingTasks = calendarState.isLoadingTasks;
    final calendarFormat = calendarState.calendarFormat;

    return Stack(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          selectedDayPredicate: (day) {
            return selectedDay != null && isSameDay(selectedDay, day);
          },
          calendarFormat: calendarFormat,
          eventLoader: (day) {
            final dateOnly = DateTime(day.year, day.month, day.day);
            return eventMarkers[dateOnly] ?? [];
          },
          onDaySelected: (selectedDay, focusedDay) {
            ref.read(calendarProvider.notifier).setSelectedDay(selectedDay);
          },
          onFormatChanged: (format) {
            ref.read(calendarProvider.notifier).setCalendarFormat(format);
          },
          onPageChanged: (page) {
            ref.read(calendarProvider.notifier).handleCalendarPageChanged(page);
          },
          calendarStyle: CalendarStyle(
            markersMaxCount: 1,
            markerSize: 6,
            markerDecoration: const BoxDecoration(
              color: AppColors.successColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: const BoxDecoration(
              color: AppColors.grey,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.getTextPrimaryColor(context),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            formatButtonShowsNext: false,
          ),
        ),

        // Subtle loading indicator that doesn't block UI
        if (isLoadingTasks && calendarState.calendarTasks.isNotEmpty)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 8,
                  height: 8,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
