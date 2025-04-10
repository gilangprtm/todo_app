import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_typografi.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Calendar Page',
            style: AppTypography.headline4.copyWith(
              color: AppColors.notionBlack,
            ),
          ),
        ),
      ),
    );
  }
}
