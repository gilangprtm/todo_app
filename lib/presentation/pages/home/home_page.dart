import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_typografi.dart';
import '../../../core/utils/mahas.dart';
import '../../../core/mahas/mahas_type.dart';
import '../../routes/app_routes.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // No need to watch the state if it's not being used in the UI
    // final state = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Search Header
        ],
      ),
    );
  }
}
