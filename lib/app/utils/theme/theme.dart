import 'package:flutter/material.dart';

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
      colorScheme: ColorScheme.fromSwatch().copyWith(
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
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        disabledColor: Colors.grey,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.pink,
        primaryContainer: Colors.pink,
      ));
}
