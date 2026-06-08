import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tokens/colors.dart';
import 'tokens/typography.dart';

ThemeData buildAppTheme() => _build(Brightness.light);
ThemeData buildDarkAppTheme() => _build(Brightness.dark);

ThemeData _build(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  final scheme = isDark
      ? const ColorScheme(
          brightness: Brightness.dark,
          primary: primary400,
          onPrimary: darkBg,
          secondary: gold300,
          onSecondary: darkBg,
          error: error500,
          onError: white,
          surface: darkSurface,
          onSurface: white,
        )
      : const ColorScheme(
          brightness: Brightness.light,
          primary: primary500,
          onPrimary: white,
          secondary: gold500,
          onSecondary: white,
          error: error500,
          onError: white,
          surface: surfaceColor,
          onSurface: gray900,
        );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: isDark ? darkBg : surfaceColor,
    cardColor: isDark ? darkCard : cardColor,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
          color: isDark ? white : gray900),
      displayMedium: AppTextStyles.displayMedium.copyWith(
          color: isDark ? white : gray900),
      titleLarge: AppTextStyles.titleLarge.copyWith(
          color: isDark ? white : gray900),
      titleMedium: AppTextStyles.titleMedium.copyWith(
          color: isDark ? white : gray900),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: isDark ? const Color(0xFFCDD9F5) : gray900),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? const Color(0xFFCDD9F5) : gray700),
      labelLarge: AppTextStyles.labelLarge.copyWith(
          color: isDark ? white : gray900),
      labelSmall: AppTextStyles.labelMedium.copyWith(
          color: isDark ? const Color(0xFF8BA5D4) : gray500),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? darkBg : white,
      foregroundColor: isDark ? white : gray900,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: isDark ? darkSurface : white,
      indicatorColor: isDark ? primary700 : primary100,
      iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
        color: states.contains(WidgetState.selected)
            ? (isDark ? primary300 : primary500)
            : (isDark ? const Color(0xFF4D6B9A) : gray500),
      )),
      labelTextStyle: WidgetStateProperty.resolveWith((states) =>
          AppTextStyles.caption.copyWith(
            color: states.contains(WidgetState.selected)
                ? (isDark ? primary300 : primary500)
                : (isDark ? const Color(0xFF4D6B9A) : gray500),
          )),
      elevation: 0,
    ),
  );
}
