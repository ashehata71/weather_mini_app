import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_handler/theme_handler.dart';

class AppThemeCubit extends Cubit<ThemeMode> {
  AppThemeCubit(this._themeHandler) : super(ThemeMode.light);

  static AppThemeCubit get(context) => BlocProvider.of(context);
  final IThemeHandler _themeHandler;

  Future<void> initTheme() async {
    await _themeHandler.loadTheme();
    emit(_themeHandler.currentTheme);
  }

  Future<void> toggleTheme() async {
    await _themeHandler.toggleTheme();
    emit(_themeHandler.currentTheme);
  }
}
