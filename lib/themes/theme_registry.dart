import 'package:cognium_frontend/themes/app_theme.dart';
import 'package:cognium_frontend/error/error_handler.dart';

class ThemeRegistry {
  final Map<String, AppTheme> _themes = {};

  void register(AppTheme theme) {
    if (_themes.containsKey(theme.id)) {
      ErrorHandler().register(
        AppError(
          category: ErrorCategory.internal,
          severity: ErrorSeverity.warning,
          code: 'THEME_ALREADY_REGISTERED',
          detail: 'Theme ${theme.name} already loaded',
          userMessage: 'Theme ${theme.name} already loaded.',
          source: 'ThemeRegistry',
        ),
      );
      return;
    }

    _themes[theme.id] = theme;
  }

  void unregister(String id) {
    _themes.remove(id);
  }

  AppTheme? get(String id) => _themes[id];

  List<AppTheme> get themes => List.unmodifiable(_themes.values);
}
