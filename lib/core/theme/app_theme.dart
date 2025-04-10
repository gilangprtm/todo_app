import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_typografi.dart';

/// A class that contains all the theme data used in the application.
/// This class provides a consistent theme system for both light and dark modes.
class AppTheme {
  // Common theme properties
  static const double _borderRadius =
      8.0; // Notion uses more subtle rounded corners
  static const double _elevation = 1.0; // Notion uses subtle shadows
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

  // Light Theme (Ghibli-Notion Theme)
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.bodyFontFamily,
    brightness: Brightness.light,
    primaryColor: AppColors.ghibliSkyBlue,
    colorScheme: const ColorScheme.light(
      primary: AppColors.ghibliSkyBlue,
      primaryContainer: AppColors.primaryLightColor,
      secondary: AppColors.ghibliForestGreen,
      secondaryContainer: AppColors.secondaryLightColor,
      tertiary: AppColors.ghibliWarmOrange,
      surface: AppColors.notionWhite,
      background: AppColors.notionWhite,
      error: AppColors.ghibliDustyRose,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.notionBlack,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.lightBackgroundColor,
    cardColor: AppColors.lightCardColor,
    cardTheme: CardTheme(
      color: AppColors.lightCardColor,
      shape: _cardShape,
      elevation: _elevation,
      shadowColor: AppColors.ghibliStoneGray.withOpacity(0.1),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.notionWhite,
      foregroundColor: AppColors.notionBlack,
      titleTextStyle: AppTypography.headline6.copyWith(
        color: AppColors.notionBlack,
      ),
      elevation: 0,
      shadowColor: AppColors.notionBlack.withOpacity(0.05),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.notionWhite,
      selectedItemColor: AppColors.ghibliSkyBlue,
      unselectedItemColor: AppColors.notionDarkGray,
      type: BottomNavigationBarType.fixed,
      elevation: 4,
      selectedLabelStyle: AppTypography.caption.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.caption,
    ),
    textTheme: TextTheme(
      displayLarge: AppTypography.headline1.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      displayMedium: AppTypography.headline2.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      displaySmall: AppTypography.headline3.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      headlineMedium: AppTypography.headline4.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      headlineSmall: AppTypography.headline5.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      titleLarge: AppTypography.headline6.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      titleMedium: AppTypography.subtitle1.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      titleSmall: AppTypography.subtitle2.copyWith(
        color: AppColors.lightTextSecondaryColor,
      ),
      bodyLarge: AppTypography.bodyText1.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      bodyMedium: AppTypography.bodyText2.copyWith(
        color: AppColors.lightTextSecondaryColor,
      ),
      labelLarge: AppTypography.button.copyWith(color: Colors.white),
      bodySmall: AppTypography.caption.copyWith(
        color: AppColors.lightTextSecondaryColor,
      ),
      labelSmall: AppTypography.overline.copyWith(
        color: AppColors.lightTextSecondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.ghibliSkyBlue,
        textStyle: AppTypography.button.copyWith(color: Colors.white),
        shape: _buttonShape,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        elevation: 1,
        shadowColor: AppColors.ghibliSkyBlue.withOpacity(0.3),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.ghibliSkyBlue,
        textStyle: AppTypography.button,
        minimumSize: const Size(88, 40),
        shape: _buttonShape,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ghibliSkyBlue,
        textStyle: AppTypography.button,
        side: const BorderSide(color: AppColors.ghibliSkyBlue, width: 1.5),
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
        borderSide: const BorderSide(color: AppColors.lightBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.lightBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(
          color: AppColors.ghibliSkyBlue,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
      labelStyle: AppTypography.formLabel.copyWith(
        color: AppColors.lightTextSecondaryColor,
      ),
      floatingLabelStyle: AppTypography.formLabel.copyWith(
        color: AppColors.ghibliSkyBlue,
      ),
      errorStyle: AppTypography.caption.copyWith(color: AppColors.errorColor),
    ),
    dialogTheme: DialogTheme(
      shape: _dialogShape,
      backgroundColor: AppColors.notionWhite,
      titleTextStyle: AppTypography.headline6.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      contentTextStyle: AppTypography.bodyText1.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      actionsPadding: const EdgeInsets.all(spacing16),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.notionBlack,
      contentTextStyle: AppTypography.bodyText1.copyWith(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.notionWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius * 2),
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDividerColor,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSecondaryColor,
      labelStyle: AppTypography.bodyText2.copyWith(
        color: AppColors.lightTextPrimaryColor,
      ),
      selectedColor: AppColors.ghibliSkyBlue,
      secondarySelectedColor: AppColors.ghibliSkyBlue,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.ghibliSkyBlue;
        }
        return AppColors.lightTextSecondaryColor;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.ghibliSkyBlue,
      unselectedLabelColor: AppColors.notionDarkGray,
      labelStyle: AppTypography.button,
      unselectedLabelStyle: AppTypography.button,
      indicator: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.ghibliSkyBlue, width: 2),
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.ghibliSkyBlue,
      circularTrackColor: AppColors.lightBackgroundColor,
      linearTrackColor: AppColors.lightBackgroundColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.ghibliSkyBlue,
      foregroundColor: Colors.white,
      elevation: 2,
      highlightElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // Dark Theme (Dark Notion-Ghibli Theme)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.bodyFontFamily,
    brightness: Brightness.dark,
    primaryColor: AppColors.ghibliSkyBlue,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.ghibliSkyBlue,
      primaryContainer: AppColors.primaryDarkColor,
      secondary: AppColors.secondaryLightColor,
      secondaryContainer: AppColors.ghibliForestGreen,
      tertiary: AppColors.ghibliWarmOrange,
      surface: AppColors.darkSurfaceColor,
      background: AppColors.darkBackgroundColor,
      error: AppColors.ghibliDustyRose,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    cardColor: AppColors.darkCardColor,
    cardTheme: CardTheme(
      color: AppColors.darkCardColor,
      shape: _cardShape,
      elevation: _elevation,
      shadowColor: Colors.black.withOpacity(0.2),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackgroundColor,
      foregroundColor: Colors.white,
      titleTextStyle: AppTypography.headline6.copyWith(color: Colors.white),
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkCardColor,
      selectedItemColor: AppColors.ghibliSkyBlue,
      unselectedItemColor: AppColors.darkTextSecondaryColor,
      selectedLabelStyle: AppTypography.caption.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.caption,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.ghibliSkyBlue,
        textStyle: AppTypography.button,
        shape: _buttonShape,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        elevation: 1,
        shadowColor: AppColors.ghibliSkyBlue.withOpacity(0.4),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.ghibliSkyBlue,
        textStyle: AppTypography.button,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ghibliSkyBlue,
        side: const BorderSide(color: AppColors.ghibliSkyBlue),
        textStyle: AppTypography.button,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(color: AppColors.darkBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: const BorderSide(
          color: AppColors.ghibliSkyBlue,
          width: 1.5,
        ),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // Method to get the current theme based on brightness
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}
