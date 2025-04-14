import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../providers/calendar/calendar_provider.dart';

class CalendarHeaderWidget extends StatelessWidget {
  const CalendarHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Kalender',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimaryColor(context),
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            return IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: AppColors.getTextPrimaryColor(context),
              ),
              onPressed: () {
                final today = DateTime.now();
                ref.read(calendarProvider.notifier).setSelectedDay(today);
              },
            );
          },
        ),
      ],
    );
  }
}
