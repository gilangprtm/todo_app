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
  final Color? textColor;
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
    this.textColor,
    this.height,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild =
        isLoading
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
                if (text != null)
                  Text(text!, style: TextStyle(color: textColor)),
              ],
            );

    switch (type) {
      case ButtonType.primary:
        return _buildElevatedButton(context, buttonChild);
      case ButtonType.secondary:
        return _buildElevatedButton(context, buttonChild);
      case ButtonType.outline:
        return _buildOutlinedButton(context, buttonChild);
      case ButtonType.text:
        return _buildTextButton(context, buttonChild);
      case ButtonType.icon:
        return _buildIconButton(context, buttonChild);
    }
  }

  Widget _buildElevatedButton(BuildContext context, Widget child) {
    final buttonColor =
        isDisabled ? Colors.grey : (color ?? Theme.of(context).primaryColor);
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: buttonColor,
          textStyle: AppTypography.button.copyWith(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          fixedSize: Size.fromHeight(height ?? 35),
          elevation: elevation ?? 2,
        ),
        onPressed: isDisabled ? null : onPressed,
        child: child,
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, Widget child) {
    final buttonColor =
        isDisabled ? Colors.grey : (color ?? Theme.of(context).primaryColor);
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          textStyle: AppTypography.button.copyWith(color: buttonColor),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          side: BorderSide(color: buttonColor),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: child,
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, Widget child) {
    final buttonColor =
        isDisabled ? Colors.grey : (color ?? Theme.of(context).primaryColor);
    final effectiveTextColor =
        isDisabled ? Colors.grey : (textColor ?? buttonColor);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: effectiveTextColor,
          textStyle: AppTypography.button.copyWith(color: effectiveTextColor),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: child,
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, Widget child) {
    final buttonColor =
        isDisabled ? Colors.grey : (color ?? Theme.of(context).primaryColor);
    return IconButton(
      icon: child,
      onPressed: isDisabled ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(buttonColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: borderRadius),
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      iconSize: 24.0,
    );
  }
}
