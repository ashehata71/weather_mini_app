import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IThemeHandler {
  ThemeMode get currentTheme;
  Future<void> toggleTheme();
  Future<void> loadTheme(); // Load saved theme on app start
}

class ThemeHandler implements IThemeHandler {
  static const _themeKey = 'isDarkMode';
  ThemeMode _currentTheme = ThemeMode.light;

  @override
  ThemeMode get currentTheme => _currentTheme;

  @override
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _currentTheme =
    _currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await prefs.setBool(_themeKey, _currentTheme == ThemeMode.dark);
  }

  @override
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    _currentTheme = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}