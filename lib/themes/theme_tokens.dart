import 'package:flutter/material.dart';

class AppColors {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color onTertiary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color disabled;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.disabled
  });
}

class BorderColors {
  final Color border;
  final Color borderSubtle;
  final Color divider;
  final Color outline;

  const BorderColors({
    required this.border,
    required this.borderSubtle,
    required this.divider,
    required this.outline,
  });
}

class StateColors {
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color onSuccess;
  final Color onWarning;
  final Color onError;
  final Color onInfo;

  const StateColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.onSuccess,
    required this.onWarning,
    required this.onError,
    required this.onInfo,
  });
}

class InteractionColors {
  final Color hover;
  final Color pressed;
  final Color selected;
  final Color focus;

  const InteractionColors({
    required this.hover,
    required this.pressed,
    required this.selected,
    required this.focus,
  });
}

class AppBorder {
  final int radius;
  final double width;

  const AppBorder({required this.radius, required this.width});
}

class AppShadows {
  final double blurRadius;
  final BlurStyle blurStyle;
  final double spread;
  final double offsetX;
  final double offsetY;

  const AppShadows({
    required this.blurRadius,
    required this.blurStyle,
    required this.spread,
    required this.offsetX,
    required this.offsetY,
  });
}
