import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/mahas/mahas_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/mahas.dart';
import 'presentation/routes/app_routes_provider.dart';
import 'presentation/providers/settings/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Buat container yang akan digunakan bersama
  final container = ProviderContainer();

  // Inisialisasi semua service melalui MahasService
  await MahasService.init(container: container);

  // Periksa apakah data sudah ada
  final String initialRoute = await MahasService.determineInitialRoute();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau theme state untuk update ketika berubah
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: AppRoutesProvider.getRoutes(),
      navigatorKey: Mahas.navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
    );
  }
}
