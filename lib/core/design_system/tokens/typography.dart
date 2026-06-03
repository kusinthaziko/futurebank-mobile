import 'package:flutter/material.dart';

class AppTextStyles {
  // Clash Display — headings, balances
  static const displayLarge = TextStyle(
    fontFamily: 'ClashDisplay', fontSize: 32, fontWeight: FontWeight.w700);
  static const displayMedium = TextStyle(
    fontFamily: 'ClashDisplay', fontSize: 24, fontWeight: FontWeight.w600);
  static const titleLarge = TextStyle(
    fontFamily: 'ClashDisplay', fontSize: 20, fontWeight: FontWeight.w600);
  static const titleMedium = TextStyle(
    fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w500);

  // Inter — body, labels
  static const bodyLarge = TextStyle(
    fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400);
  static const bodyMedium = TextStyle(
    fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400);
  static const labelLarge = TextStyle(
    fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600);
  static const labelMedium = TextStyle(
    fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500);
  static const caption = TextStyle(
    fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400);
}
