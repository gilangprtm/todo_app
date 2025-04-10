import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. State - Simple immutable state untuk counter
class CounterState {
  final int count;

  const CounterState({this.count = 0});

  // Metode copyWith untuk mempertahankan immutability
  CounterState copyWith({int? count}) {
    return CounterState(
      count: count ?? this.count,
    );
  }
}

// 2. Notifier - Mengontrol state dan menyediakan metode manipulasi
class CounterNotifier extends StateNotifier<CounterState> {
  // Inisialisasi dengan state default
  CounterNotifier() : super(const CounterState());

  // Metode untuk menambah nilai counter
  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  // Metode untuk mengurangi nilai counter
  void decrement() {
    state = state.copyWith(count: state.count - 1);
  }

  // Metode untuk mereset nilai counter
  void reset() {
    state = const CounterState();
  }
}

// 3. Provider - Mengekspos StateNotifier dan State ke UI
final counterProvider =
    StateNotifierProvider<CounterNotifier, CounterState>((ref) {
  return CounterNotifier();
});

// 4. UI - Menggunakan provider untuk mengakses dan memodifikasi state
class CounterPage extends ConsumerWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 5. Mengakses state menggunakan ref.watch
    final count = ref.watch(counterProvider).count;

    // 6. Mengakses notifier untuk memanggil metode
    final counterNotifier = ref.read(counterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Example'),
        actions: [
          // 7. Tombol reset
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => counterNotifier.reset(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            // 8. Menampilkan nilai counter dari state
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // 9. Optimized rebuild demo
            const CounterControls(),
          ],
        ),
      ),
    );
  }
}

// 10. Widget yang dioptimasi dengan select
class CounterControls extends ConsumerWidget {
  const CounterControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Menggunakan notifier tanpa memicu rebuild saat state berubah
    final counterNotifier = ref.read(counterProvider.notifier);

    // Hanya untuk demonstrasi: print saat widget di-rebuild
    print('CounterControls rebuilt');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 11. Tombol decrement
        ElevatedButton(
          onPressed: () => counterNotifier.decrement(),
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 20),
        // 12. Tombol increment
        ElevatedButton(
          onPressed: () => counterNotifier.increment(),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

// 13. Menggunakan ConsumerStatefulWidget jika perlu
class CounterPageStateful extends ConsumerStatefulWidget {
  const CounterPageStateful({Key? key}) : super(key: key);

  @override
  ConsumerState<CounterPageStateful> createState() =>
      _CounterPageStatefulState();
}

class _CounterPageStatefulState extends ConsumerState<CounterPageStateful> {
  @override
  void initState() {
    super.initState();
    // 14. Akses provider di initState
    // Gunakan ref.read() di dalam initState, bukan ref.watch()
    final initialCount = ref.read(counterProvider).count;
    print('Initial count: $initialCount');
  }

  @override
  Widget build(BuildContext context) {
    // 15. Di dalam build, gunakan ref.watch() untuk memicu rebuild saat state berubah
    final count = ref.watch(counterProvider).count;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter StatefulWidget Example'),
      ),
      body: Center(
        child: Text('Count: $count'),
      ),
    );
  }
}

// 16. Contoh penggunaan select untuk optimasi performa
class OptimizedCounterDisplay extends ConsumerWidget {
  const OptimizedCounterDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 17. Menggunakan select untuk memilih bagian tertentu dari state
    // Widget ini hanya akan di-rebuild jika nilai count berubah
    final count = ref.watch(counterProvider.select((state) => state.count));

    print('OptimizedCounterDisplay rebuilt');

    return Text(
      'Current count: $count',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
