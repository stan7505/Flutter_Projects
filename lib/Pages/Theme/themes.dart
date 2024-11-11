import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade900,
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade700,
    secondary: Colors.grey.shade800,
    tertiary: Colors.grey.shade600,
    inversePrimary: Colors.grey.shade100,
  ),
);

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeData _themeData = lightMode;

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    setThemeBasedOnSystemBrightness(WidgetsBinding.instance.window.platformBrightness);
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }

  void setThemeBasedOnSystemBrightness(Brightness brightness) {
    _themeData = brightness == Brightness.dark ? darkMode : lightMode;
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    setThemeBasedOnSystemBrightness(brightness);
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}