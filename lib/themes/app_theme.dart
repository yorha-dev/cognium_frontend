import 'package:flutter/material.dart';

import 'package:cognium_frontend/themes/theme_tokens.dart';

enum ThemeVariants { light, dark }

abstract class AppTheme {
  String get id;
  String get name;

  VariantTheme get light;
  VariantTheme get dark;

  Map<ThemeVariants, VariantTheme> get themes => {
    ThemeVariants.light: light,
    ThemeVariants.dark: dark,
  };

  VariantTheme resolve(ThemeVariants variant) {
    return switch (variant) {
      ThemeVariants.light => light,
      ThemeVariants.dark => dark,
    };
  }
}

class VariantTheme {
  final ThemeVariants variant;

  final AppColors appColors;
  final BorderColors borderColors;
  final StateColors stateColors;
  final InteractionColors interactionColors;

  final AppBorder appBorder;
  final AppShadows appShadows;

  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: switch (variant) {
      ThemeVariants.light => Brightness.light,
      ThemeVariants.dark => Brightness.dark,
    },
    colorScheme: ColorScheme(
      brightness: switch (variant) {
        ThemeVariants.light => Brightness.light,
        ThemeVariants.dark => Brightness.dark,
      },
      surface: appColors.background,
      onSurface: appColors.onSurface,
      surfaceContainer: appColors.surface,
      surfaceContainerHighest: appColors.surfaceVariant,
      primary: appColors.primary,
      onPrimary: appColors.onPrimary,
      secondary: appColors.secondary,
      onSecondary: appColors.onSecondary,
      tertiary: appColors.tertiary,
      onTertiary: appColors.onTertiary,
      error: stateColors.error,
      onError: stateColors.onError,
    ),
  );

  VariantTheme({
    required this.variant,
    required this.appColors,
    required this.borderColors,
    required this.stateColors,
    required this.interactionColors,
    required this.appBorder,
    required this.appShadows,
  });
}
