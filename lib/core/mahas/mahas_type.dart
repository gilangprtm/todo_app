import 'package:flutter/material.dart';

class AppImages {
  static const String placeholder = 'assets/placeholder.png';
  static const String sampleSvg = 'assets/sample.svg';
}

enum MenuType {
  normal,
  underlined,
  pill,
  iconOnly,
}

enum ButtonType {
  primary,
  secondary,
  outline,
  text,
  icon,
}

enum AlertType {
  info,
  confirmation,
  error,
  succes,
}

enum BadgePosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  center,
}

enum MahasAvatarType {
  image,
  icon,
  outline,
}

enum MahasAvatarSize {
  small,
  medium,
  large,
}

enum MahasToastPosition {
  top,
  bottom,
}

class MahasBorderRadius {
  static const BorderRadius none = BorderRadius.zero;
  static const BorderRadius small = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius large = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius extraLarge =
      BorderRadius.all(Radius.circular(32.0));
  static const BorderRadius circle = BorderRadius.all(Radius.circular(50.0));
  static const BorderRadius ellipse = BorderRadius.all(Radius.circular(100.0));
}

enum MahasTypographyType {
  title,
  subtitle,
  s,
  m,
  l,
  xl,
}
