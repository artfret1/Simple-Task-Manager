import 'package:flutter/material.dart';

class MainTheme {
  MainTheme({
    required this.name,
    required this.mainColor,
    required this.optionalColor,
    required this.textTheme,
    required this.appBarColor,
    required this.floatingActionButton,
  });

  final String name;
  final Color mainColor;
  final Color optionalColor;
  final TextTheme textTheme;
  final Color appBarColor;
  final FloatingActionButtonThemeData floatingActionButton;

  ThemeData toThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: mainColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarColor,
        titleTextStyle: textTheme.bodyLarge,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: floatingActionButton,
    );
  }
}
