import 'package:flutter/material.dart';

import 'package:cognium_frontend/themes/app_theme.dart';
import 'package:cognium_frontend/themes/theme_tokens.dart';

class DefaultTheme extends AppTheme {
  @override
  String get id => 'automata';

  @override
  String get name => 'Automata';

  @override
  VariantTheme get light => VariantTheme(
    variant: ThemeVariants.light,
    appColors: AppColors(
      primary: Color(0xFF77715F),
      onPrimary: Color(0xFFF0E8C9),
      secondary: Color(0xFF696657),
      onSecondary: Color(0xFFF0E8C9),
      tertiary: Color(0xFFB8A16C),
      onTertiary: Color(0xFF292923),
      accent: Color(0xFF77715F),
      background: Color(0xFFD9D4B9),
      surface: Color(0xFFE5E0C9),
      surfaceVariant: Color(0xFFC6C1A9),
      onSurface: Color(0xFF36352E),
      disabled: Color(0xFFAAA58F),
    ),
    borderColors: BorderColors(
      border: Color(0xFFAAA58F),
      borderSubtle: Color(0xFFBDB8A1),
      divider: Color(0xFFBDB8A1),
      outline: Color(0xFF77715F),
    ),
    stateColors: StateColors(
      success: Color(0xFF777568),
      onSuccess: Color(0xFFF0E8C9),
      warning: Color(0xFFB8A16C),
      onWarning: Color(0xFF292923),
      error: Color(0xFFB98275),
      onError: Color(0xFF292923),
      info: Color(0xFFA7A084),
      onInfo: Color(0xFF292923),
    ),
    interactionColors: InteractionColors(
      hover: Color(0xFFC6C1A9),
      pressed: Color(0xFFAAA58F),
      selected: Color(0xFFBDB8A1),
      focus: Color(0xFF77715F),
    ),
    appBorder: AppBorder(radius: 8, width: 1.0),
    appShadows: AppShadows(
      blurRadius: 8.0,
      blurStyle: BlurStyle.normal,
      spread: 0.0,
      offsetX: 0.0,
      offsetY: 2.0,
    ),
  );

  @override
  VariantTheme get dark => VariantTheme(
    variant: ThemeVariants.dark,
    appColors: AppColors(
      primary: Color(0xFFC0B58E),
      onPrimary: Color(0xFF292923),
      secondary: Color(0xFFAAA58F),
      onSecondary: Color(0xFF292923),
      tertiary: Color(0xFFB8A16C),
      onTertiary: Color(0xFF292923),
      accent: Color(0xFFC0B58E),
      background: Color(0xFF292923),
      surface: Color(0xFF36352E),
      surfaceVariant: Color(0xFF514F42),
      onSurface: Color(0xFFE2DEC9),
      disabled: Color(0xFF686657),
    ),
    borderColors: BorderColors(
      border: Color(0xFF686657),
      borderSubtle: Color(0xFF444339),
      divider: Color(0xFF444339),
      outline: Color(0xFFC0B58E),
    ),
    stateColors: StateColors(
      success: Color(0xFF777568),
      onSuccess: Color(0xFFF0E8C9),
      warning: Color(0xFFB8A16C),
      onWarning: Color(0xFF292923),
      error: Color(0xFFB98275),
      onError: Color(0xFF292923),
      info: Color(0xFFA7A084),
      onInfo: Color(0xFF292923),
    ),
    interactionColors: InteractionColors(
      hover: Color(0xFF444339),
      pressed: Color(0xFF514F42),
      selected: Color(0xFF514F42),
      focus: Color(0xFFC0B58E),
    ),
    appBorder: AppBorder(radius: 8, width: 1.0),
    appShadows: AppShadows(
      blurRadius: 10.0,
      blurStyle: BlurStyle.normal,
      spread: 0.0,
      offsetX: 0.0,
      offsetY: 3.0,
    ),
  );
}
