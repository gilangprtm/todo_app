import 'package:flutter/material.dart';

/// A class that contains all the colors used in the application.
/// This class provides a consistent color palette for both light and dark themes.
class AppColors {
  // Ghibli-Notion Theme Colors
  static const Color ghibliSkyBlue = Color(
    0xFF7CB2D2,
  ); // Soft sky blue like in Ghibli films
  static const Color ghibliForestGreen = Color(
    0xFF5A8268,
  ); // Peaceful forest green
  static const Color ghibliCream = Color(
    0xFFF9F2E0,
  ); // Warm cream common in Ghibli backgrounds
  static const Color ghibliWarmOrange = Color(0xFFE58F65); // Warm sunset orange
  static const Color ghibliDustyRose = Color(0xFFD16B54); // Dusty rose accent
  static const Color ghibliStoneGray = Color(
    0xFF6D7A72,
  ); // Stone gray from Ghibli landscapes

  // Notion-inspired UI colors
  static const Color notionWhite = Color(
    0xFFFFFFF8,
  ); // Slightly warmer white like Notion
  static const Color notionBlack = Color(0xFF2F3437); // Soft black
  static const Color notionGray = Color(0xFFEBECEA); // Light gray for surfaces
  static const Color notionDarkGray = Color(0xFF9B9B9B); // For secondary text
  static const Color notionBorder = Color(0xFFE5E5E5); // Subtle border color

  // Primary Colors (Ghibli-Notion themed)
  static const Color primaryColor = ghibliSkyBlue;
  static const Color primaryLightColor = Color(0xFFA1CADE); // Lighter sky blue
  static const Color primaryDarkColor = Color(0xFF5891B0); // Darker sky blue

  // Secondary Colors
  static const Color secondaryColor = ghibliForestGreen;
  static const Color secondaryLightColor = Color(
    0xFF7CA38A,
  ); // Lighter forest green
  static const Color accentColor = ghibliWarmOrange;

  // Status Colors
  static const Color errorColor = ghibliDustyRose;
  static const Color successColor = Color(0xFF52A87D); // Green success
  static const Color warningColor = Color(0xFFE6B450); // Warm yellow warning
  static const Color infoColor = primaryColor;

  // Status Colors with Opacity
  static Color errorColorWithOpacity(double opacity) =>
      errorColor.withValues(alpha: opacity);
  static Color successColorWithOpacity(double opacity) =>
      successColor.withValues(alpha: opacity);
  static Color warningColorWithOpacity(double opacity) =>
      warningColor.withValues(alpha: opacity);
  static Color infoColorWithOpacity(double opacity) =>
      infoColor.withValues(alpha: opacity);

  // Utility Colors
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFFD3D3D3);

  // Disabled State Colors
  static const Color disabledColor = Color(0xFFE5E5E5);
  static const Color disabledTextColor = Color(0xFFAAAAAA);

  // Divider and Border Colors
  static const Color dividerColor = notionBorder;
  static const Color borderColor = notionBorder;

  // Overlay Colors
  static const Color overlayColor = Color(0x80000000);
  static const Color modalOverlayColor = Color(0x40000000);

  // Light Mode Colors
  static const Color lightSecondaryColor = notionGray;
  static const Color lightSecondaryLightColor = notionWhite;
  static const Color lightSecondaryDarkColor = Color(0xFFE0E0E0);

  static const Color lightBackgroundColor = notionWhite;
  static const Color lightSurfaceColor = ghibliCream;
  static const Color lightCardColor = notionWhite;

  static const Color lightTextPrimaryColor = notionBlack;
  static const Color lightTextSecondaryColor = notionDarkGray;

  // Light Mode Additional Colors
  static const Color lightDividerColor = notionBorder;
  static const Color lightBorderColor = notionBorder;
  static const Color lightDisabledColor = Color(0xFFEEEEEE);
  static const Color lightDisabledTextColor = Color(0xFFB5B5B5);

  // Dark Mode Colors
  static const Color darkSecondaryColor = Color(0xFF2D3133);
  static const Color darkSecondaryLightColor = Color(0xFF3A3E40);
  static const Color darkSecondaryDarkColor = Color(0xFF232728);

  static const Color darkBackgroundColor = Color(0xFF191C1E);
  static const Color darkSurfaceColor = Color(0xFF2D3133);
  static const Color darkCardColor = Color(0xFF2D3133);

  static const Color darkTextPrimaryColor = Color(0xFFF7F6F3);
  static const Color darkTextSecondaryColor = Color(0xFFB6B6B4);

  // Dark Mode Additional Colors
  static const Color darkDividerColor = Color(0xFF3A3E40);
  static const Color darkBorderColor = Color(0xFF3A3E40);
  static const Color darkDisabledColor = Color(0xFF3A3E40);
  static const Color darkDisabledTextColor = Color(0xFF656565);

  // Gradient Decorations
  static BoxDecoration get ghibliSkyGradientDecoration => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF85C7ED), // Light sky
        ghibliSkyBlue,
      ],
    ),
  );

  // Ghibli-inspired pattern box decoration
  static BoxDecoration get ghibliCardDecoration => BoxDecoration(
    color: notionWhite,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.07),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
    border: Border.all(color: notionBorder, width: 1),
    borderRadius: BorderRadius.circular(12),
  );
}
