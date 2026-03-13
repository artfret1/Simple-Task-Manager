import 'package:flutter/material.dart';
import 'main_theme.dart';

final nativeTheme = MainTheme(
  name: "native",
  mainColor: const Color(0xFF1F2E56),
  optionalColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white70, fontSize: 14),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
  ),
  appBarColor: const Color(0xFF1F2E56),
  floatingActionButton: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 90, 150, 255),
    elevation: 8,
  ),
);

final darkTheme = MainTheme(
  name: "dark",
  mainColor: const Color(0xFF0A1226),
  optionalColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white70, fontSize: 14),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
  ),
  appBarColor: const Color(0xFF0A1226),
  floatingActionButton: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(200, 90, 150, 255),
    elevation: 10,
  ),
);
