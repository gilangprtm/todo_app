import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_color.dart';

class AddTaskPage extends ConsumerWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title field
          TextField(
            decoration: InputDecoration(
              labelText: 'Task Title',
              hintText: 'Enter task title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // Description field
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Add task description (optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // Due date picker
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Show date picker
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Due Date',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const Icon(Icons.calendar_today, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Priority selector
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Priority',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const Icon(Icons.flag, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24.0),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add task logic
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Add Task'),
            ),
          ),
        ],
      ),
    );
  }
}
