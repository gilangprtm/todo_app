# Simple Counter Example

Contoh sederhana ini menunjukkan dasar-dasar penggunaan Riverpod untuk manajemen state dengan kasus counter. Contoh ini mengilustrasikan konsep-konsep dasar seperti:

1. Mendefinisikan state immutable
2. Membuat StateNotifier untuk memanipulasi state
3. Mendaftarkan provider yang mengekspos notifier dan state
4. Menggunakan berbagai cara mengakses state di UI dengan Consumer widgets
5. Mengoptimalkan rebuild dengan `select`

## Komponen

### CounterState

```dart
class CounterState {
  final int count;

  const CounterState({this.count = 0});

  CounterState copyWith({int? count}) {
    return CounterState(
      count: count ?? this.count,
    );
  }
}
```

- State sederhana yang berisi nilai counter
- Immutable (tidak dapat diubah langsung)
- Menyediakan metode `copyWith()` untuk membuat instance baru dengan nilai yang diperbarui

### CounterNotifier

```dart
class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(const CounterState());

  void increment() {
    state = state.copyWith(count: state.count + 1);
  }

  void decrement() {
    state = state.copyWith(count: state.count - 1);
  }

  void reset() {
    state = const CounterState();
  }
}
```

- Extends `StateNotifier<CounterState>` dari Riverpod
- Menyediakan metode untuk memanipulasi state (increment, decrement, reset)
- Menggunakan copyWith untuk memperbarui state dan menjaga immutability

### Provider

```dart
final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>((ref) {
  return CounterNotifier();
});
```

- Menggunakan `StateNotifierProvider` untuk mengekspos notifier dan state
- Mengaitkan `CounterNotifier` dengan provider sehingga dapat diakses di UI

## Cara Penggunaan di UI

### ConsumerWidget

```dart
class CounterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state
    final count = ref.watch(counterProvider).count;

    // Read notifier untuk mengakses metode
    final counterNotifier = ref.read(counterProvider.notifier);

    return Scaffold(
      // UI implementation...
    );
  }
}
```

- Menggunakan `ConsumerWidget` sebagai alternatif `StatelessWidget`
- `ref.watch()` untuk mendengarkan perubahan state dan memicu rebuild
- `ref.read()` untuk mengakses notifier dan memanggil metode tanpa mendengarkan perubahan

### Optimasi dengan Select

```dart
class OptimizedCounterDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hanya mendengarkan perubahan pada properti count
    final count = ref.watch(counterProvider.select((state) => state.count));

    return Text('Current count: $count');
  }
}
```

- Menggunakan `select` untuk hanya mendengarkan perubahan pada properti tertentu
- Widget hanya akan di-rebuild jika nilai yang dipilih berubah
- Sangat berguna untuk state yang kompleks dengan banyak properti

### ConsumerStatefulWidget

```dart
class CounterPageStateful extends ConsumerStatefulWidget {
  @override
  ConsumerState<CounterPageStateful> createState() => _CounterPageStatefulState();
}

class _CounterPageStatefulState extends ConsumerState<CounterPageStateful> {
  @override
  void initState() {
    super.initState();
    // Gunakan ref.read() di initState
    final initialCount = ref.read(counterProvider).count;
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan ref.watch() di build
    final count = ref.watch(counterProvider).count;

    return Scaffold(
      // UI implementation...
    );
  }
}
```

- `ConsumerStatefulWidget` dan `ConsumerState` sebagai alternatif `StatefulWidget`
- Dalam `initState()` atau method lifecycle lain, gunakan `ref.read()` untuk menghindari exception
- Dalam `build()`, gunakan `ref.watch()` untuk mendengarkan perubahan

## Praktik Terbaik

1. **Jaga state immutable**: Selalu gunakan copyWith untuk memperbarui state
2. **Pisahkan state dan logic**: Logic berada di notifier, state hanya menyimpan data
3. **Gunakan select**: Optimalkan performa dengan hanya mendengarkan properti yang diperlukan
4. **Hindari watch di method lifecycle**: Gunakan read pada initState, didChangeDependencies, dll.

## Extensions

Contoh ini bisa diperluas dengan:

1. Menambahkan properti lebih kompleks ke state
2. Menambahkan validasi (misalnya, count tidak boleh negatif)
3. Menambahkan persistensi dengan SharedPreferences
4. Menambahkan unit test untuk notifier
