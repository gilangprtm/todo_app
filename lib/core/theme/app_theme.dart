import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_typografi.dart';

/// A class that contains all the theme data used in the application.
/// This class provides a consistent theme system following Notion's minimalist design.
class AppTheme {
  // Common theme properties
  static const double _borderRadius = 8.0;
  static const double _elevation = 1.0;
  static const double borderRadius = _borderRadius;
  static const double elevation = _elevation;

  // Spacing constants
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Shape constants
  static final RoundedRectangleBorder _cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(_borderRadius),
  );

  static final RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(_borderRadius),
  );

  static final RoundedRectangleBorder _dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(_borderRadius),
  );

  // Light Theme (Notion-inspired)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.bodyFontFamily,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      primaryContainer: AppColors.primaryLightColor,
      secondary: AppColors.textSecondaryColor,
      secondaryContainer: AppColors.textTertiaryColor,
      surface: AppColors.backgroundColor,
      error: AppColors.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    cardColor: AppColors.cardColor,
    cardTheme: CardTheme(
      color: AppColors.cardColor,
      shape: _cardShape,
      elevation: _elevation,
      shadowColor: AppColors.black.withValues(alpha: 0.05),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: AppColors.textPrimaryColor,
      titleTextStyle: AppTypography.headline6.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      elevation: 0,
      shadowColor: AppColors.black.withValues(alpha: 0.05),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundColor,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.textSecondaryColor,
      type: BottomNavigationBarType.fixed,
      elevation: 4,
      selectedLabelStyle: AppTypography.caption.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.caption,
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.headline1.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      displayMedium: AppTypography.headline2.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      displaySmall: AppTypography.headline3.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      headlineMedium: AppTypography.headline4.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      headlineSmall: AppTypography.headline5.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      titleLarge: AppTypography.headline6.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      titleMedium: AppTypography.subtitle1.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      titleSmall: AppTypography.subtitle2.copyWith(
        color: AppColors.textSecondaryColor,
      ),
      bodyLarge: AppTypography.bodyText1.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      bodyMedium: AppTypography.bodyText2.copyWith(
        color: AppColors.textSecondaryColor,
      ),
      labelLarge: AppTypography.button.copyWith(color: Colors.white),
      bodySmall: AppTypography.caption.copyWith(
        color: AppColors.textSecondaryColor,
      ),
      labelSmall: AppTypography.overline.copyWith(
        color: AppColors.textSecondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        textStyle: AppTypography.button.copyWith(color: Colors.white),
        shape: _buttonShape,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        elevation: 1,
        shadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        textStyle: AppTypography.button,
        minimumSize: const Size(88, 40),
        shape: _buttonShape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        textStyle: AppTypography.button,
        side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
        minimumSize: const Size(88, 44),
        shape: _buttonShape,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
      labelStyle: AppTypography.formLabel.copyWith(
        color: AppColors.textSecondaryColor,
      ),
      floatingLabelStyle: AppTypography.formLabel.copyWith(
        color: AppColors.primaryColor,
      ),
      errorStyle: AppTypography.caption.copyWith(color: AppColors.errorColor),
    ),
    dialogTheme: DialogTheme(
      shape: _dialogShape,
      backgroundColor: AppColors.backgroundColor,
      titleTextStyle: AppTypography.headline6.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      contentTextStyle: AppTypography.bodyText1.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      actionsPadding: const EdgeInsets.all(spacing16),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryColor,
      contentTextStyle: AppTypography.bodyText1.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius * 2),
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerColor,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.grey,
      labelStyle: AppTypography.bodyText2.copyWith(
        color: AppColors.textPrimaryColor,
      ),
      selectedColor: AppColors.primaryColor,
      secondarySelectedColor: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }
        return AppColors.textSecondaryColor;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: AppColors.textSecondaryColor,
      labelStyle: AppTypography.button,
      unselectedLabelStyle: AppTypography.button,
      indicator: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryColor,
      circularTrackColor: AppColors.backgroundColor,
      linearTrackColor: AppColors.backgroundColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      highlightElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // Dark Theme (Notion-inspired)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.bodyFontFamily,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      primaryContainer: AppColors.primaryDarkColor,
      secondary: AppColors.darkTextSecondaryColor,
      secondaryContainer: AppColors.textTertiaryColor,
      surface: AppColors.darkBackgroundColor,
      error: AppColors.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkTextPrimaryColor,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    cardColor: AppColors.darkCardColor,
    cardTheme: CardTheme(
      color: AppColors.darkCardColor,
      shape: _cardShape,
      elevation: _elevation,
      shadowColor: AppColors.black.withValues(alpha: 0.2),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackgroundColor,
      foregroundColor: AppColors.darkTextPrimaryColor,
      titleTextStyle: AppTypography.headline6.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      elevation: 0,
      shadowColor: AppColors.black.withValues(alpha: 0.2),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackgroundColor,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.darkTextSecondaryColor,
      type: BottomNavigationBarType.fixed,
      elevation: 4,
      selectedLabelStyle: AppTypography.caption.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.caption,
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.headline1.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      displayMedium: AppTypography.headline2.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      displaySmall: AppTypography.headline3.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      headlineMedium: AppTypography.headline4.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      headlineSmall: AppTypography.headline5.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      titleLarge: AppTypography.headline6.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      titleMedium: AppTypography.subtitle1.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      titleSmall: AppTypography.subtitle2.copyWith(
        color: AppColors.darkTextSecondaryColor,
      ),
      bodyLarge: AppTypography.bodyText1.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      bodyMedium: AppTypography.bodyText2.copyWith(
        color: AppColors.darkTextSecondaryColor,
      ),
      labelLarge: AppTypography.button.copyWith(color: Colors.white),
      bodySmall: AppTypography.caption.copyWith(
        color: AppColors.darkTextSecondaryColor,
      ),
      labelSmall: AppTypography.overline.copyWith(
        color: AppColors.darkTextSecondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        textStyle: AppTypography.button.copyWith(color: Colors.white),
        shape: _buttonShape,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        elevation: 1,
        shadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        textStyle: AppTypography.button,
        minimumSize: const Size(88, 40),
        shape: _buttonShape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        textStyle: AppTypography.button,
        side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
        minimumSize: const Size(88, 44),
        shape: _buttonShape,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCardColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.darkBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.darkBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
      labelStyle: AppTypography.formLabel.copyWith(
        color: AppColors.darkTextSecondaryColor,
      ),
      floatingLabelStyle: AppTypography.formLabel.copyWith(
        color: AppColors.primaryColor,
      ),
      errorStyle: AppTypography.caption.copyWith(color: AppColors.errorColor),
    ),
    dialogTheme: DialogTheme(
      shape: _dialogShape,
      backgroundColor: AppColors.darkBackgroundColor,
      titleTextStyle: AppTypography.headline6.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      contentTextStyle: AppTypography.bodyText1.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      actionsPadding: const EdgeInsets.all(spacing16),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primaryColor,
      contentTextStyle: AppTypography.bodyText1.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius * 2),
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDividerColor,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.greyDark,
      labelStyle: AppTypography.bodyText2.copyWith(
        color: AppColors.darkTextPrimaryColor,
      ),
      selectedColor: AppColors.primaryColor,
      secondarySelectedColor: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }
        return AppColors.darkTextSecondaryColor;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: AppColors.darkTextSecondaryColor,
      labelStyle: AppTypography.button,
      unselectedLabelStyle: AppTypography.button,
      indicator: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryColor,
      circularTrackColor: AppColors.darkBackgroundColor,
      linearTrackColor: AppColors.darkBackgroundColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      highlightElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // Method to get the current theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}
