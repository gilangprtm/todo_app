import 'package:flutter/material.dart';

class MahasBottomSheet {
  /// Shows a modal bottom sheet with Mahas styling
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? height,
    String? title,
    double? elevation,
    ShapeBorder? shape,
    Color? backgroundColor,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: height ?? MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                Theme.of(context).bottomSheetTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: SingleChildScrollView(child: child)),
            ],
          ),
        );
      },
    );
  }
}
