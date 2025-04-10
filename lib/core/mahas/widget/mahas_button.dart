import 'package:flutter/material.dart';

import '../../theme/app_typografi.dart';
import '../mahas_type.dart';

class MahasButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isDisabled;
  final bool isFullWidth;
  final bool isLoading;
  final Widget? icon;
  final BorderRadius borderRadius;
  final Color? color;
  final double? height;
  final double? elevation;

  const MahasButton({
    super.key,
    this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isDisabled = false,
    this.isFullWidth = false,
    this.isLoading = false,
    this.icon,
    this.borderRadius = MahasBorderRadius.medium,
    this.color,
    this.height,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2.5,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                if (text != null) const SizedBox(width: 8),
              ],
              if (text != null) Text(text!),
            ],
          );

    switch (type) {
      case ButtonType.primary:
        return _buildElevatedButton(buttonChild, color: color);
      case ButtonType.secondary:
        return _buildElevatedButton(buttonChild, color: color);
      case ButtonType.outline:
        return _buildOutlinedButton(buttonChild);
      case ButtonType.text:
        return _buildTextButton(buttonChild);
      case ButtonType.icon:
        return _buildIconButton(buttonChild);
    }
  }

  Widget _buildElevatedButton(Widget child, {Color? color}) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isDisabled ? Colors.grey : (color),
          textStyle: AppTypography.button,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          fixedSize: Size.fromHeight(height ?? 35),
          elevation: elevation ?? 2,
        ),
        onPressed: isDisabled ? null : onPressed,
        child: child,
      ),
    );
  }

  Widget _buildOutlinedButton(Widget child) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDisabled ? Colors.grey : color,
          textStyle: AppTypography.button,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          side: BorderSide(
            color: isDisabled ? Colors.grey : color!,
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: child,
      ),
    );
  }

  Widget _buildTextButton(Widget child) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: isDisabled ? Colors.grey : color,
          textStyle: AppTypography.button,
        ),
        onPressed: isDisabled ? null : onPressed,
        child: child,
      ),
    );
  }

  Widget _buildIconButton(Widget child) {
    return IconButton(
      icon: child,
      onPressed: isDisabled ? null : onPressed,
      color: isDisabled ? Colors.grey : color,
      padding: const EdgeInsets.all(8.0),
      iconSize: 24.0,
    );
  }
}
