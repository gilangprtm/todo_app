import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../providers/calendar/calendar_provider.dart';

class StatsHeaderWidget extends StatelessWidget {
  const StatsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Stats',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimaryColor(context),
          ),
        ),
      ],
    );
  }
}
