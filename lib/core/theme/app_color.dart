import 'package:flutter/material.dart';

/// A class that contains all the colors used in the application.
/// This class provides a consistent color system following Notion's minimalist design.
class AppColors {
  // Base colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Primary colors - Notion blue
  static const Color primaryColor = Color(0xFF2F80ED);
  static const Color primaryLightColor = Color(0xFFE6F0FF);
  static const Color primaryDarkColor = Color(0xFF1A4B9A);

  // Text colors
  static const Color textPrimaryColor = Color(0xFF2F3437);
  static const Color textSecondaryColor = Color(0xFF9B9B9B);
  static const Color textTertiaryColor = Color(0xFFC4C4C4);
  static const Color textInverseColor = Color(0xFFFFFFFF);

  // Background colors
  static const Color backgroundColor = Color(0xFFFFFFF8);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFEBECEA);

  // Border colors
  static const Color borderColor = Color(0xFFE5E5E5);
  static const Color dividerColor = Color(0xFFE5E5E5);

  // Status colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color infoColor = Color(0xFF2196F3);

  // Neutral colors
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyDark = Color(0xFF616161);

  // Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF232728);
  static const Color darkCardColor = Color(0xFF2F3437);
  static const Color darkSurfaceColor = Color(0xFF1A1D1E);
  static const Color darkTextPrimaryColor = Color(0xFFF8F8F8);
  static const Color darkTextSecondaryColor = Color(0xFF9B9B9B);
  static const Color darkBorderColor = Color(0xFF3D3D3D);
  static const Color darkDividerColor = Color(0xFF3D3D3D);

  // Helper method to get theme-aware colors
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? backgroundColor
        : darkBackgroundColor;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? cardColor
        : darkCardColor;
  }

  static Color getTextPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? textPrimaryColor
        : darkTextPrimaryColor;
  }

  static Color getTextSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? textSecondaryColor
        : darkTextSecondaryColor;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? borderColor
        : darkBorderColor;
  }

  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? dividerColor
        : darkDividerColor;
  }

  // Status Colors with Opacity
  static Color successColorWithOpacity(double opacity) =>
      successColor.withValues(alpha: opacity);
  static Color errorColorWithOpacity(double opacity) =>
      errorColor.withValues(alpha: opacity);
  static Color warningColorWithOpacity(double opacity) =>
      warningColor.withValues(alpha: opacity);
  static Color infoColorWithOpacity(double opacity) =>
      infoColor.withValues(alpha: opacity);

  // Task Status Colors
  static Color getStatusColor(BuildContext context, int status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (status) {
      case 0: // Pending
        return isDark ? Colors.grey[700]! : Colors.grey[400]!;
      case 1: // In Progress
        return isDark ? Colors.blue[300]! : Colors.blue;
      case 2: // Completed
        return isDark ? Colors.green[300]! : Colors.green;
      default:
        return isDark ? Colors.grey[700]! : Colors.grey[400]!;
    }
  }

  static Color getStatusBackgroundColor(BuildContext context, int status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (status) {
      case 1: // In Progress
        return isDark
            ? Colors.blue.withValues(alpha: 0.15)
            : Colors.blue.withValues(alpha: 0.05);
      case 2: // Completed
        return isDark
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.green.withValues(alpha: 0.05);
      default:
        return getCardColor(context);
    }
  }

  // Progress Indicator Colors
  static Color getProgressBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF424242);
  }

  static Color getProgressForegroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF4CAF50)
        : const Color(0xFF66BB6A);
  }

  // Priority Colors
  static Color getPriorityColor(BuildContext context, int priority) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (priority == 2) {
      // High priority
      return isDark ? Colors.red[300]! : Colors.red;
    }
    return getTextSecondaryColor(context);
  }

  // Utility Colors
  static const Color transparent = Colors.transparent;

  // Disabled State Colors
  static const Color disabledColor = Color(0xFFE5E5E5);
  static const Color disabledTextColor = Color(0xFFAAAAAA);

  // Overlay Colors
  static const Color overlayColor = Color(0x80000000);
  static const Color modalOverlayColor = Color(0x40000000);

  // Notion-inspired UI colors for light theme
  static const Color notionWhite = Color(
    0xFFFFFFF8,
  ); // Slightly warmer white like Notion
  static const Color notionBlack = Color(0xFF2F3437); // Soft black
  static const Color notionGray = Color(0xFFEBECEA); // Light gray for surfaces
  static const Color notionDarkGray = Color(0xFF9B9B9B); // For secondary text
  static const Color notionBorder = Color(0xFFE5E5E5); // Subtle border color

  // Notion-inspired UI colors for dark theme
  static const Color notionDarkWhite = Color(
    0xFFF8F8F8,
  ); // Slightly warmer white like Notion
  static const Color notionDarkBlack = Color(0xFF232728); // Darker black
  static const Color notionDarkGrayDark = Color(
    0xFFEBECEA,
  ); // Light gray for surfaces
  static const Color notionDarkDarkGray = Color(
    0xFF9B9B9B,
  ); // For secondary text
  static const Color notionDarkBorder = Color(
    0xFFE5E5E5,
  ); // Subtle border color

  // Card Decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    boxShadow: [
      BoxShadow(
        color: black.withValues(alpha: 0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
    border: Border.all(color: borderColor, width: 1),
    borderRadius: BorderRadius.circular(12),
  );

  // Input Decoration
  static BoxDecoration get inputDecoration => BoxDecoration(
    color: white,
    border: Border.all(color: borderColor, width: 1),
    borderRadius: BorderRadius.circular(8),
  );

  // Button Colors
  static const Color buttonColor = primaryColor;
  static const Color buttonTextColor = white;
  static const Color buttonDisabledColor = disabledColor;
  static const Color buttonDisabledTextColor = disabledTextColor;

  // Icon Colors
  static const Color iconColor = textPrimaryColor;
  static const Color iconSecondaryColor = textSecondaryColor;
  static const Color iconDisabledColor = disabledTextColor;

  // Selection Colors
  static const Color selectionColor = Color(0xFFE3F2FD); // Light blue
  static const Color hoverColor = Color(0xFFF5F5F5); // Light gray

  // Progress Colors
  static const Color progressBackgroundColor = Color(0xFFE0E0E0);
  static const Color progressColor = primaryColor;
}
