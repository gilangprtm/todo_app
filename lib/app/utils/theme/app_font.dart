import 'package:flutter/material.dart';
import 'theme.dart';

class AppFont {
  static TextStyle get h1 => const TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get input => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get label => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get headerblack => const TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: AppColor.blackComponent);

  static TextStyle get headerwhite => const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColor.white,
      );

  static TextStyle get tittle => const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColor.blackComponent);

  static TextStyle get subtittle => const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColor.blackComponent);
}
