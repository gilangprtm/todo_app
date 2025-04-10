import 'package:flutter/material.dart';

/// Kelas utilitas utama yang menyediakan berbagai fungsi helper untuk aplikasi
///
/// Untuk menggunakan Mahas, Anda perlu menginisialisasi context dan navigatorKey di awal aplikasi.
/// Contoh penggunaan di main.dart:
/// ```dart
/// void main() {
///   runApp(MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     // Inisialisasi context Mahas
///     Mahas.setContext(context);
///
///     return MaterialApp(
///       navigatorKey: Mahas.navigatorKey,
///       home: HomePage(),
///     );
///   }
/// }
/// ```
class Mahas {
  // =============== Navigation Key ===============
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Mendapatkan navigator state
  static NavigatorState? get navigator => navigatorKey.currentState;

  /// Mendapatkan context dari navigator
  static BuildContext? get context => navigator?.context;

  // =============== Parameter Management ===============
  static Map<String, String> _parameters = {};

  /// Mengatur parameter query untuk navigasi
  static void setParameters(Map<String, String> params) {
    _parameters = params;
  }

  /// Mendapatkan semua parameter query
  static Map<String, String> parameters() {
    return _parameters;
  }

  /// Membersihkan semua parameter query
  static void clearParameters() {
    _parameters.clear();
  }

  // =============== Argument Management ===============
  static Map<String, dynamic> _arguments = {};

  /// Mengatur argument untuk navigasi
  static void setArguments(Map<String, dynamic> args) {
    _arguments = args;
  }

  /// Mendapatkan semua argument
  static Map<String, dynamic> arguments() {
    return _arguments;
  }

  /// Mendapatkan argument dengan tipe tertentu
  static T? argument<T>(String key) {
    return _arguments[key] as T?;
  }

  /// Mengecek keberadaan argument
  static bool hasArgument(String key) {
    return _arguments.containsKey(key);
  }

  /// Menghapus argument tertentu
  static void removeArgument(String key) {
    _arguments.remove(key);
  }

  /// Membersihkan semua argument
  static void clearArguments() {
    _arguments.clear();
  }

  // =============== Navigation Methods ===============

  /// Navigasi ke halaman baru
  static Future<T?> routeTo<T>(
    String routeName, {
    Map<String, dynamic>? arguments,
    Map<String, String>? params,
  }) async {
    if (arguments != null) {
      setArguments(arguments);
    }
    if (params != null) {
      setParameters(params);
    }

    return await navigator?.pushNamed<T>(routeName);
  }

  /// Navigasi ke halaman baru dan menghapus semua halaman sebelumnya
  static Future<T?> routeToAndRemove<T>(
    String routeName, {
    Map<String, dynamic>? arguments,
    Map<String, String>? params,
  }) async {
    if (arguments != null) {
      setArguments(arguments);
    }
    if (params != null) {
      setParameters(params);
    }
    return await navigator?.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
    );
  }

  /// Navigasi ke halaman baru dan mengganti halaman saat ini
  static Future<T?> routeToAndReplace<T>(
    String routeName, {
    Map<String, dynamic>? arguments,
    Map<String, String>? params,
  }) async {
    if (arguments != null) {
      setArguments(arguments);
    }
    if (params != null) {
      setParameters(params);
    }
    return await navigator?.pushReplacementNamed<T, T>(routeName);
  }

  /// Navigasi ke halaman baru dan menghapus halaman sampai kondisi terpenuhi
  static Future<T?> routeToAndRemoveUntil<T>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Map<String, dynamic>? arguments,
    Map<String, String>? params,
  }) async {
    if (arguments != null) {
      setArguments(arguments);
    }
    if (params != null) {
      setParameters(params);
    }
    return await navigator?.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
    );
  }

  /// Kembali ke halaman sebelumnya
  static void back<T>([T? result]) {
    clearArguments();
    navigator?.pop<T>(result);
  }

  /// Kembali ke halaman sampai kondisi terpenuhi
  static void backUntil(bool Function(Route<dynamic>) predicate) {
    clearArguments();
    navigator?.popUntil(predicate);
  }

  /// Kembali ke halaman pertama
  static void backToFirst() {
    clearArguments();
    navigator?.popUntil((route) => route.isFirst);
  }

  /// Kembali ke halaman dengan nama tertentu
  static void backToNamed(String routeName) {
    clearArguments();
    navigator?.popUntil((route) => route.settings.name == routeName);
  }

  // =============== UI Methods ===============

  /// Menampilkan snackbar
  static void snackbar(String title, String message) {
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text('$title: $message'),
        ),
      );
    }
  }

  /// Menampilkan dialog
  static Future<void> dialog(Widget dialog) async {
    if (context != null) {
      showDialog(
        context: context!,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    }
  }

  /// Menampilkan bottom sheet
  static Future<T?> bottomSheet<T>(Widget bottomSheet) async {
    if (context != null) {
      return await showModalBottomSheet<T>(
        context: context!,
        builder: (BuildContext context) {
          return bottomSheet;
        },
      );
    }
    return null;
  }

  // =============== Localization & Theme ===============

  /// Mendapatkan locale saat ini
  static Locale? locale() {
    // Implementasi logika lokalisasi
    return null;
  }

  /// Mendapatkan tema saat ini
  static ThemeData? theme() {
    // Implementasi logika manajemen tema
    return null;
  }
}
