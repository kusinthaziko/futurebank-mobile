import 'package:flutter/material.dart';

/// Custom brand colors not covered by the Material 3 ColorScheme.
///
/// Access via `Theme.of(context).extension<FbColors>()`.
class FbColors extends ThemeExtension<FbColors> {
  /// Primary brand gold — used for highlights, badges, premium indicators.
  final Color gold;

  /// Tinted background for gold-accented surfaces (e.g. notification banners).
  final Color goldLight;

  /// Deep teal — used for dark headers, bottoms sheets, brand-consistent
  /// dark surfaces outside the M3 surface palette.
  final Color tealDark;

  const FbColors({
    required this.gold,
    required this.goldLight,
    required this.tealDark,
  });

  @override
  FbColors copyWith({
    Color? gold,
    Color? goldLight,
    Color? tealDark,
  }) =>
      FbColors(
        gold: gold ?? this.gold,
        goldLight: goldLight ?? this.goldLight,
        tealDark: tealDark ?? this.tealDark,
      );

  @override
  FbColors lerp(FbColors other, double t) => FbColors(
        gold: Color.lerp(gold, other.gold, t)!,
        goldLight: Color.lerp(goldLight, other.goldLight, t)!,
        tealDark: Color.lerp(tealDark, other.tealDark, t)!,
      );

  /// Light-mode brand colors.
  factory FbColors.light() => const FbColors(
        gold: Color(0xFFFF8F00),
        goldLight: Color(0xFFFFF8E1),
        tealDark: Color(0xFF004D40),
      );

  /// Dark-mode brand colors.
  factory FbColors.dark() => const FbColors(
        gold: Color(0xFFFFB300),      // brighter gold pops on dark
        goldLight: Color(0xFF332200), // deep amber tint, not muddy
        tealDark: Color(0xFF4DB6AC),  // brighter teal for readability
      );
}
