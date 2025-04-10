import 'package:flutter/material.dart';

import '../mahas_type.dart';

class MahasToast {
  static void show({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    BorderRadius borderRadius = MahasBorderRadius.medium,
    MahasToastPosition position = MahasToastPosition.bottom,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MahasToastDialog(
        message: message,
        backgroundColor: backgroundColor,
        textColor: textColor,
        duration: duration,
        borderRadius: borderRadius,
        position: position,
      ),
    );
  }
}

class _MahasToastDialog extends StatefulWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;
  final Duration duration;
  final BorderRadius borderRadius;
  final MahasToastPosition position;

  const _MahasToastDialog({
    required this.message,
    required this.backgroundColor,
    this.textColor,
    required this.duration,
    required this.borderRadius,
    required this.position,
  });

  @override
  State<_MahasToastDialog> createState() => __MahasToastDialogState();
}

class __MahasToastDialogState extends State<_MahasToastDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(
          0.0, widget.position == MahasToastPosition.bottom ? 1.0 : -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: widget.position == MahasToastPosition.top ? 50.0 : null,
            bottom: widget.position == MahasToastPosition.bottom ? 50.0 : null,
            left: 20.0,
            right: 20.0,
            child: SlideTransition(
              position: _offsetAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: widget.borderRadius,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
