import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // No need to watch the state if it's not being used in the UI
    // final state = ref.watch(homeProvider);

    return const Scaffold(
      backgroundColor: Colors.white,
      body: const Center(child: Text('Home Page')),
    );
  }
}
