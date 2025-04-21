import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/mahas/inputs/input_dropdown_component.dart';
import '../../../providers/stats/stats_provider.dart';
import '../../../providers/stats/stats_state.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  const DateRangeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final selectedRange = ref.watch(
          statsProvider.select((state) => state.dateRange),
        );

        final dropdownController = InputDropdownController(
          items:
              DateRange.values
                  .map((range) => DropdownItem(text: range.label, value: range))
                  .toList(),
          onChanged: (item) {
            if (item != null && item.value is DateRange) {
              ref.read(statsProvider.notifier).setDateRange(item.value);
            }
          },
        );

        // Set the initial value
        dropdownController.value = selectedRange;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InputDropdownComponent(
            controller: dropdownController,
            label: 'Date Range',
            marginBottom: 0,
          ),
        );
      },
    );
  }
}
