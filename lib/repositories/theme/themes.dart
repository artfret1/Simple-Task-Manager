import 'package:flutter/material.dart';
import 'main_theme.dart';

final nativeTheme = MainTheme(
  name: "native",
  mainColor: const Color.fromARGB(255, 35, 61, 133),
  optionalColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white70, fontSize: 14),
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    labelMedium: TextStyle(color: Colors.white, fontSize: 22),
    labelLarge: TextStyle(color: Colors.white, fontSize: 28),
  ),
  appBarColor: const Color.fromARGB(255, 35, 61, 133),
  floatingActionButton: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 120, 149, 230),
  ),
);

final darkTheme = MainTheme(
  name: "dark",
  mainColor: const Color.fromARGB(255, 9, 18, 43),
  optionalColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white70, fontSize: 14),
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    labelMedium: TextStyle(color: Colors.white, fontSize: 22),
    labelLarge: TextStyle(color: Colors.white, fontSize: 28),
  ),
  appBarColor: const Color.fromARGB(255, 9, 18, 43),
  floatingActionButton: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(153, 120, 149, 230),
  ),
);
