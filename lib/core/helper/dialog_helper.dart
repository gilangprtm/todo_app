import 'package:flutter/material.dart';

import '../mahas/mahas_type.dart';
import '../mahas/widget/mahas_alert.dart';
import '../utils/mahas.dart';

final context = Mahas.context;

class DialogHelper {
  static void showErrorDialog(String message) {
    showDialog(
      context: context!,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.error,
          content: Text(message),
          showNegativeButton: false,
          showPositiveButton: true,
        );
      },
    );
  }

  static void showInfoDialog(String message) {
    showDialog(
      context: context!,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.info,
          content: Text(message),
          showNegativeButton: false,
          showPositiveButton: true,
        );
      },
    );
  }

  static void showSuccessDialog({String message = ''}) {
    showDialog(
      context: context!,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.succes,
          content: Text(message),
          showNegativeButton: false,
          showPositiveButton: true,
        );
      },
    );
  }

  static Future<bool> showConfirmationDialog({
    String message = '',
    Function? onPositivePressed,
    Function? onNegativePressed,
  }) async {
    return await showDialog(
      context: context!,
      builder: (context) {
        return MahasAlertDialog(
          alertType: AlertType.confirmation,
          content: Text(message),
          onPositivePressed: () {
            Navigator.of(context).pop(true);
            onPositivePressed;
            return true;
          },
          onNegativePressed: () {
            Navigator.of(context).pop(false);
            onNegativePressed;
            return false;
          },
        );
      },
    );
  }

  static Future dialogFullScreen(Widget child) async {
    await showDialog(
      context: context!,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
