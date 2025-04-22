import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../providers/stats/stats_provider.dart';

class ActivityHeatmapWidget extends ConsumerStatefulWidget {
  const ActivityHeatmapWidget({super.key});

  @override
  ConsumerState<ActivityHeatmapWidget> createState() =>
      _ActivityHeatmapWidgetState();
}

class _ActivityHeatmapWidgetState extends ConsumerState<ActivityHeatmapWidget> {
  DateTime? selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityData = ref.watch(
      statsProvider.select((state) => state.activityData),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: constraints.maxWidth,
                child: MonthCalendarHeatmap(
                  activityData: activityData,
                  onDateSelected: (date) {},
                  selectedDate: selectedDate,
                  currentMonth: _currentMonth,
                  onPreviousMonth: _previousMonth,
                  onNextMonth: _nextMonth,
                ),
              ),
              _buildLegend(),
              if (selectedDate != null) ...[
                const SizedBox(height: 16),
                _buildSelectedDateTasks(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Less', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          ...List.generate(5, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getColorForCount(index / 4),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
          const SizedBox(width: 4),
          const Text('More', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0: // pending
        return Colors.grey;
      case 1: // in progress
        return Colors.orange;
      case 2: // completed
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getColorForCount(double normalizedCount) {
    if (normalizedCount <= 0) {
      return Colors.grey.shade200;
    } else if (normalizedCount < 0.25) {
      return Colors.green.shade100;
    } else if (normalizedCount < 0.5) {
      return Colors.green.shade300;
    } else if (normalizedCount < 0.75) {
      return Colors.green.shade500;
    } else {
      return Colors.green.shade700;
    }
  }

  Widget _buildSelectedDateTasks(BuildContext context) {
    final tasksOnSelectedDate = ref.watch(
      statsProvider.select((state) => state.tasksOnSelectedDate),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SelectedDateHeader(date: selectedDate!),
        const SizedBox(height: 8),
        if (tasksOnSelectedDate.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No tasks on this date'),
          )
        else
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tasksOnSelectedDate.length,
            itemBuilder: (context, index) {
              final task = tasksOnSelectedDate[index];
              return ListTile(
                dense: true,
                title: Text(task.title),
                subtitle: Text(
                  task.tags.isNotEmpty
                      ? task.tags.map((t) => t.name).join(', ')
                      : 'No tags',
                ),
                leading: Icon(
                  Icons.circle,
                  size: 12,
                  color: _getStatusColor(task.status),
                ),
              );
            },
          ),
      ],
    );
  }
}

class MonthCalendarHeatmap extends StatelessWidget {
  final Map<DateTime, int> activityData;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime currentMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const MonthCalendarHeatmap({
    super.key,
    required this.activityData,
    this.selectedDate,
    required this.onDateSelected,
    required this.currentMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  Color _getColorForCount(double normalizedCount) {
    if (normalizedCount <= 0) {
      return Colors.grey.shade200;
    } else if (normalizedCount < 0.25) {
      return Colors.green.shade100;
    } else if (normalizedCount < 0.5) {
      return Colors.green.shade300;
    } else if (normalizedCount < 0.75) {
      return Colors.green.shade500;
    } else {
      return Colors.green.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get first day of month and calculate offset
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final dayOffset = firstDayOfMonth.weekday - 1; // 0 = Monday, 6 = Sunday

    // Calculate days in month
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    // Calculate required rows and total cells
    // First calculate how many cells needed for the current month
    final totalDaysWithOffset = daysInMonth + dayOffset;

    // Calculate how many rows needed (7 days per row)
    (totalDaysWithOffset / 7).ceil();

    // Calculate total cells (rows × 7)

    // Adjust for special cases
    int itemCount = 35; // Default is 5 rows (35 cells)

    // Case 1: If 1st is Sunday and month has 29 days or fewer, use 35 cells
    if (dayOffset == 6 && daysInMonth <= 29) {
      itemCount = 35;
    }
    // Case 2: If 1st is Saturday and month has 31 days, use 42 cells
    else if (dayOffset == 5 && daysInMonth == 31) {
      itemCount = 42;
    }
    // Case 3: If month requires more than 35 cells, use 42
    else if (totalDaysWithOffset > 35) {
      itemCount = 42;
    }

    // Find max activity count for normalization
    final maxCount =
        activityData.values.isEmpty
            ? 1
            : activityData.values.reduce(
              (max, value) => max > value ? max : value,
            );

    return Column(
      children: [
        // Month navigation header
        _buildMonthHeader(context),

        // Weekday headers
        _buildWeekdayHeaders(context),

        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            // Calculate day number (1-based)
            final dayIndex = index - dayOffset;

            // If day is outside current month, render empty cell
            if (dayIndex < 0 || dayIndex >= daysInMonth) {
              return Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }

            final day = dayIndex + 1;
            final date = DateTime(currentMonth.year, currentMonth.month, day);

            // Get activity count for this date
            final count =
                activityData[DateTime(date.year, date.month, date.day)] ?? 0;

            // Normalize count between 0 and 1 for color intensity
            final normalizedCount =
                maxCount > 0 ? (count / maxCount).toDouble() : 0.0;

            final isSelected =
                selectedDate != null &&
                selectedDate!.year == date.year &&
                selectedDate!.month == date.month &&
                selectedDate!.day == date.day;

            // Check if this is today
            final isToday =
                DateTime.now().year == date.year &&
                DateTime.now().month == date.month &&
                DateTime.now().day == day;

            return GestureDetector(
              onTap: () => onDateSelected(date),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _getColorForCount(normalizedCount),
                  borderRadius: BorderRadius.circular(4),
                  border:
                      isSelected
                          ? Border.all(color: Colors.black, width: 1)
                          : isToday
                          ? Border.all(color: Colors.blue, width: 1)
                          : null,
                ),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color:
                          normalizedCount > 0.5 ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMonthHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPreviousMonth,
            tooltip: 'Previous month',
          ),
          Text(
            '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNextMonth,
            tooltip: 'Next month',
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            weekdays
                .map(
                  (day) => SizedBox(
                    width: 36,
                    child: Text(
                      day,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

class _SelectedDateHeader extends StatelessWidget {
  final DateTime date;

  const _SelectedDateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    // Format date as "Day, Month Date"
    final formattedDate =
        '${_getDayName(date.weekday)}, ${_getMonthName(date.month)} ${date.day}';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: AppColors.getTextPrimaryColor(context),
          ),
          const SizedBox(width: 8),
          Text(
            formattedDate,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
