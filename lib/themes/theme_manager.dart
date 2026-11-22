import 'package:flutter/material.dart';

import 'package:cognium_frontend/themes/theme_registry.dart';
import 'package:cognium_frontend/themes/app_theme.dart';

class ThemeManager extends ChangeNotifier {
  final ThemeRegistry registry;

  String _activeTheme = 'automata';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeManager({required this.registry});

  String get activeTheme => _activeTheme;
  ThemeMode get themeMode => _themeMode;

  Map<ThemeVariants, VariantTheme> get themes {
    final theme = registry.get(_activeTheme);

    if (theme == null) {
      throw StateError('Active theme not found');
    }

    return theme.themes;
  }

  void setTheme(String id) {
    if (registry.get(id) == null) {
      throw ArgumentError('Unknow theme: $id');
    }

    if (_activeTheme == id) return;

    _activeTheme = id;
    notifyListeners();
  }

  void setMode(ThemeMode mode) {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();
  }
}
