import 'package:flutter/material.dart';

import '../../theme/app_color.dart';
import '../mahas_type.dart';

class MahasAlertDialog extends StatelessWidget {
  final AlertType alertType;
  final String? title;
  final Widget? content;
  final bool showNegativeButton;
  final bool showPositiveButton;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final Color? backgroundColor;
  final Function()? onPositivePressed;
  final Function()? onNegativePressed;

  const MahasAlertDialog({
    super.key,
    required this.alertType,
    this.title,
    this.content,
    this.showNegativeButton = true,
    this.showPositiveButton = true,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onPositivePressed,
    this.onNegativePressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = Theme.of(context).dialogTheme.backgroundColor;
    Color iconColor;
    IconData iconData;
    String dialogTitle = '';

    // Set properties based on alert type
    switch (alertType) {
      case AlertType.info:
        backgroundColor = this.backgroundColor ?? backgroundColor;
        iconData = Icons.info_outline;
        iconColor = Colors.blue;
        dialogTitle = title ?? 'Info';
        break;
      case AlertType.confirmation:
        backgroundColor = this.backgroundColor ?? backgroundColor;
        iconData = Icons.help_outline;
        iconColor = AppColors.warningColor;
        dialogTitle = title ?? 'Confirmation';
        break;
      case AlertType.error:
        backgroundColor = this.backgroundColor ?? backgroundColor;
        iconData = Icons.cancel_outlined;
        iconColor = AppColors.errorColor;
        dialogTitle = title ?? 'Error';
        break;
      case AlertType.succes:
        backgroundColor = this.backgroundColor ?? backgroundColor;
        iconData = Icons.check;
        iconColor = Colors.green;
        dialogTitle = title ?? 'Transaction Successful!';
        break;
    }

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Circular icon at the top
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),

            // Dialog title
            Text(
              dialogTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Content
            if (content != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DefaultTextStyle(
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                  child: content!,
                ),
              ),

            const SizedBox(height: 24),

            // Buttons
            if (showPositiveButton || showNegativeButton)
              Row(
                children: [
                  // Primary button
                  if (showPositiveButton)
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            onPositivePressed != null
                                ? () {
                                  Navigator.of(context).pop();
                                  onPositivePressed!();
                                }
                                : () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: iconColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          positiveButtonText ?? 'OK',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Add space between buttons
                  if (showPositiveButton && showNegativeButton)
                    const SizedBox(width: 10),

                  // Secondary button
                  if (showNegativeButton)
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            onNegativePressed != null
                                ? () {
                                  Navigator.of(context).pop();
                                  onNegativePressed!();
                                }
                                : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          negativeButtonText ?? 'Cancel',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
