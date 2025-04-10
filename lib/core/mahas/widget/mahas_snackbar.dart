import 'package:flutter/material.dart';

class MahasSnackbar {
  static void show(BuildContext context, String message,
      {Color? backgroundColor,
      Duration duration = const Duration(seconds: 3)}) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
