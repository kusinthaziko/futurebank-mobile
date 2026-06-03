import 'package:flutter/material.dart';
import 'tokens/colors.dart';
import 'tokens/typography.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary500,
      onPrimary: white,
      secondary: gold500,
      onSecondary: white,
      error: error500,
      onError: white,
      surface: surfaceColor,
      onSurface: gray900,
    ),
    scaffoldBackgroundColor: surfaceColor,
    cardColor: cardColor,
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      labelLarge: AppTextStyles.labelLarge,
      labelSmall: AppTextStyles.labelMedium,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      foregroundColor: gray900,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
