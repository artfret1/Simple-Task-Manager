import 'package:flutter/material.dart';
import 'main_theme.dart';
import 'themes.dart';

class ThemeProvider extends ChangeNotifier {
  MainTheme _currentTheme = darkTheme;

  MainTheme get currentTheme => _currentTheme;

  void setTheme(MainTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
