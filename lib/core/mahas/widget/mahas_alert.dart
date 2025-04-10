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
    Color? backgroundColor = Theme.of(context).dialogBackgroundColor;
    Color? iconColor;
    IconData iconData;
    String title = '';
    switch (alertType) {
      case AlertType.info:
        backgroundColor = this.backgroundColor ?? backgroundColor;
        iconData = Icons.info_outline;
        title = this.title ?? 'Info';
        break;
      case AlertType.confirmation:
        backgroundColor = this.backgroundColor ?? backgroundColor;
        iconData = Icons.help_outline;
        iconColor = AppColors.warningColor;
        title = this.title ?? 'Confirmation';
        break;
      case AlertType.error:
        backgroundColor = this.backgroundColor ?? backgroundColor;
        iconData = Icons.cancel_outlined;
        iconColor = AppColors.errorColor;
        title = this.title ?? 'Error';
        break;
      case AlertType.succes:
        backgroundColor = this.backgroundColor ?? backgroundColor;
        iconData = Icons.done;
        iconColor = AppColors.successColor;
        title = this.title ?? 'Success';
        break;
    }

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 16,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(iconData, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: iconColor),
                  ),
                ],
              ),
            ),
            if (content != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: content!,
              ),
            if (!showNegativeButton && !showPositiveButton)
              const SizedBox(height: 16),
            if ((showNegativeButton || showPositiveButton) && content != null)
              OverflowBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (showNegativeButton)
                    TextButton(
                      onPressed: onNegativePressed != null
                          ? () {
                              Navigator.of(context).pop();
                              onNegativePressed!();
                            }
                          : () => Navigator.of(context).pop(),
                      child: Text(negativeButtonText ?? 'Cancel'),
                    ),
                  if (showPositiveButton)
                    TextButton(
                      onPressed: onPositivePressed != null
                          ? () {
                              Navigator.of(context).pop();
                              onPositivePressed!();
                            }
                          : () => Navigator.of(context).pop(),
                      child: Text(positiveButtonText ?? 'OK'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
