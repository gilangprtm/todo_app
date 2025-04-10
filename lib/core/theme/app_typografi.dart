import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

/// A class that contains all the typography styles used in the application.
/// This class provides a consistent typography system for both light and dark themes.
class AppTypography {
  // Font families - Notion-like clean fonts with a hint of Ghibli warmth
  static final String headingFontFamily = GoogleFonts.notoSans().fontFamily!;
  static final String bodyFontFamily = GoogleFonts.lato().fontFamily!;

  // Headline styles - Clean and minimal like Notion with Ghibli warmth
  static TextStyle headline1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle headline2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 36.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle headline3 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle headline4 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.25,
    height: 1.2,
  );

  static TextStyle headline5 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle headline6 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
    height: 1.2,
  );

  // Subtitle styles
  static TextStyle subtitle1 = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle subtitle2 = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
  );

  // Body styles - Clean and readable like Notion
  static TextStyle bodyText1 = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static TextStyle bodyText2 = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    height: 1.5,
  );

  // Button styles
  static TextStyle button = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    height: 1.5,
  );

  // Caption styles
  static TextStyle caption = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    height: 1.5,
  );

  // Overline styles
  static TextStyle overline = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 1.5,
    height: 1.5,
  );

  // Link styles
  static TextStyle link = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    height: 1.5,
    color: AppColors.primaryColor,
    decoration: TextDecoration.underline,
  );

  // List item styles
  static TextStyle listItem = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    height: 1.5,
  );

  // Form label styles - Clean and minimal like Notion
  static TextStyle formLabel = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.5,
  );

  // Todo-specific styles
  static TextStyle todoTitle = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.3,
  );

  static TextStyle todoDate = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.ghibliStoneGray,
    height: 1.2,
  );

  static TextStyle todoTag = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static TextStyle todoSubtask = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
  );

  static TextStyle muted = const TextStyle(
    color: AppColors.notionDarkGray,
    height: 1.5,
  );

  // Helper method for creating a style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // Helper method for creating a style with custom weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
}
