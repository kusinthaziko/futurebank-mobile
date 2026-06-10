import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/typography.dart';
import 'extensions/fb_colors.dart';

ThemeData buildAppTheme() => _build(Brightness.light);
ThemeData buildDarkAppTheme() => _build(Brightness.dark);

ThemeData _build(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF00695C), // Deep teal — trust, growth, financial stability
    brightness: brightness,
  ).copyWith(
    secondary: const Color(0xFFFF8F00), // Gold — premium, aspirational
    tertiary: const Color(0xFF7C4DFF),  // Purple — AI/fintech accent
  );

  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    cardColor: scheme.surfaceContainerHigh,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
          color: scheme.onSurface),
      displayMedium: AppTextStyles.displayMedium.copyWith(
          color: scheme.onSurface),
      titleLarge: AppTextStyles.titleLarge.copyWith(
          color: scheme.onSurface),
      titleMedium: AppTextStyles.titleMedium.copyWith(
          color: scheme.onSurface),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: isDark ? scheme.onSurfaceVariant : scheme.onSurface),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: scheme.onSurfaceVariant),
      labelLarge: AppTextStyles.labelLarge.copyWith(
          color: scheme.onSurface),
      labelSmall: AppTextStyles.labelMedium.copyWith(
          color: scheme.onSurfaceVariant),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    ),
    extensions: [
      isDark ? FbColors.dark() : FbColors.light(),
    ],
  );
}
