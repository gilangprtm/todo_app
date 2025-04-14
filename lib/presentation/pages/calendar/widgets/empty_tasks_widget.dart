import 'package:flutter/material.dart';

class EmptyTasksWidget extends StatelessWidget {
  final ScrollController scrollController;

  const EmptyTasksWidget({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/empty_tasks.png',
              height: 150,
              errorBuilder:
                  (context, _, __) => const Icon(
                    Icons.event_busy,
                    size: 100,
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daftar tugas kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Beristirahatlah, semoga harimu menyenangkan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
