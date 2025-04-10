import 'package:flutter/material.dart';

class MahasBottomSheet extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? elevation;
  final String? title;
  final ShapeBorder? shape;
  final Color? backgroundColor;

  const MahasBottomSheet({
    super.key,
    required this.child,
    this.height,
    this.title,
    this.elevation,
    this.shape,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: backgroundColor ??
            Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: shape != null
            ? const BorderRadius.only(
                topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
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
          Expanded(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
