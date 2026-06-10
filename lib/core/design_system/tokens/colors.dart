// DEPRECATION NOTICE
//
// These hardcoded color tokens are being replaced by the Material 3 ColorScheme
// (generated via ColorScheme.fromSeed in theme/app_theme.dart) and the FbColors
// ThemeExtension (theme/extensions/fb_colors.dart).
//
// - Primary/surface/error tokens → M3 ColorScheme (scheme.primary, scheme.surface, …)
// - Brand gold / teal → FbColors extension accessed via
//   `Theme.of(context).extension<FbColors>()`
// - Semantic colors (success, warning, error) → move to FbColors or use
//   Material 3 scheme.error + custom extensions
//
// TODO: Migrate all usages and remove this file in Phase 1.

import 'package:flutter/material.dart';

// Primary — electric blue
const primary900 = Color(0xFF0A1628);
const primary800 = Color(0xFF0C1F45);
const primary700 = Color(0xFF0D2F6E);
const primary500 = Color(0xFF1A56DB);
const primary400 = Color(0xFF4D7FE8);
const primary300 = Color(0xFF76A9FA);
const primary100 = Color(0xFFE8F0FE);

// Accent — warm gold
const gold500 = Color(0xFFD4A017);
const gold300 = Color(0xFFE8C547);
const gold100 = Color(0xFFFDF3C5);

// Semantic
const success500 = Color(0xFF0D9B64);
const success100 = Color(0xFFD1FAE5);
const warning500 = Color(0xFFF59E0B);
const warning100 = Color(0xFFFEF3C7);
const error500   = Color(0xFFDC2626);
const error100   = Color(0xFFFEE2E2);

// Neutrals
const gray900 = Color(0xFF111827);
const gray700 = Color(0xFF374151);
const gray500 = Color(0xFF6B7280);
const gray300 = Color(0xFFD1D5DB);
const gray100 = Color(0xFFF3F4F6);
const white   = Color(0xFFFFFFFF);

// Surfaces — light
const surfaceColor = Color(0xFFFAFAFA);
const cardColor    = Color(0xFFFFFFFF);

// Surfaces — dark
const darkBg       = Color(0xFF060D1A);
const darkSurface  = Color(0xFF0D1B30);
const darkCard     = Color(0xFF122040);
const darkBorder   = Color(0xFF1E3A5F);
