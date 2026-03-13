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
      useMaterial3: true,

      scaffoldBackgroundColor: mainColor,
      textTheme: textTheme,

      // APP BAR
      appBarTheme: AppBarTheme(
        backgroundColor: appBarColor,
        titleTextStyle: textTheme.labelMedium,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      // CARDS
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.08),
        elevation: 8,
        shadowColor: Colors.blueAccent.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.blueAccent.withOpacity(0.45),
            width: 1.6,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),

      // POPUP DIALOG
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.black.withOpacity(0.65),
        surfaceTintColor: Colors.transparent,
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Colors.blueAccent.withOpacity(0.35),
            width: 1.4,
          ),
        ),
      ),

      dialogBackgroundColor: Colors.black.withOpacity(0.4),

      // INPUT FIELDS
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.55)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent.withOpacity(0.3),
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent.withOpacity(0.8),
            width: 1.7,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // BUTTONS
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.white.withOpacity(0.18);
            }
            return Colors.blueAccent.withOpacity(0.85);
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shadowColor: WidgetStateProperty.all(
            Colors.blueAccent.withOpacity(0.4),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      // FAB
      floatingActionButtonTheme: floatingActionButton.copyWith(
        backgroundColor: Colors.blueAccent.withOpacity(0.25),
        foregroundColor: Colors.white,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Colors.blueAccent.withOpacity(0.7),
            width: 2.0,
          ),
        ),
        splashColor: Colors.blueAccent.withOpacity(0.3),
        focusColor: Colors.blueAccent.withOpacity(0.4),
        hoverColor: Colors.blueAccent.withOpacity(0.25),
      ),
    );
  }
}
