import 'package:flutter/material.dart';
import 'package:todo_hive/app/utils/theme/app_color.dart';

export 'app_font.dart';
export 'app_color.dart';

ThemeData darkTheme() {
  return ThemeData.dark().copyWith(
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Poppins',
          ),
      primaryTextTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Poppins',
          ),
      brightness: Brightness.dark,
      primaryColor: Colors.amber,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.amber,
        disabledColor: Colors.grey,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.primary,
        titleTextStyle: TextStyle(
          color: AppColor.white,
          fontSize: 18,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColor.primary,
        secondary: Colors.red,
      ));
}

ThemeData lightTheme() {
  return ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
        ),
    primaryColor: Colors.blue,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      disabledColor: Colors.grey,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColor.primary,
    ),
  );
}
