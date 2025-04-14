import 'package:flutter/material.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/calendar_table_widget.dart';
import './widgets/task_list_header_widget.dart';
import './widgets/tasks_list_widget.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar header
              CalendarHeaderWidget(),

              // Calendar widget
              CalendarTableWidget(),

              SizedBox(height: 24),

              // Task list header
              TaskListHeaderWidget(),

              // Task list
              TasksListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
