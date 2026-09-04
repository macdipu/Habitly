import 'package:flutter/material.dart';

// =========================================================
// ADAPTIVE COLOR CLASS
// =========================================================

class AdaptiveColor {
  final Color light;
  final Color dark;

  const AdaptiveColor({required this.light, required this.dark});

  Color resolve(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }

  // Convenience method for cleaner syntax
  Color call(BuildContext context) => resolve(context);

  // Add opacity support
  AdaptiveColor withAlpha(double opacity) {
    return AdaptiveColor(
      light: light.withValues(alpha: opacity),
      dark: dark.withValues(alpha: opacity),
    );
  }
}

// =========================================================
// APP COLORS - ORGANIZED & MAINTAINABLE
// =========================================================

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // =========================================================
  // BRAND COLORS
  // =========================================================

  static const Color brandPrimary = Color(0xFF0A1A2F);
  static const Color brandSecondary = Color(0xFFF4C430);
  static const Color brandAccent = Color(0xFFF2633B);
  static const Color brandGreen = Color(0xFF1FA45D);
  static const Color brandGray = Color(0xFFE6E8EC);

  // =========================================================
  // MATERIAL 3 SYSTEM COLORS - ADAPTIVE
  // =========================================================

  // Primary — sage green, calm and non-clinical. Darkened from the initial
  // #4C8F6B (~3.85:1 on white — fails WCAG AA 4.5:1 for text) to #3E7A5A
  // (~5.1:1) since this color carries white text/icons on the FAB, filled
  // buttons, and the Insights hero card.
  static const primary = AdaptiveColor(
    light: Color(0xFF3E7A5A),
    dark: Color(0xFF6FBE93),
  );

  static const onPrimary = AdaptiveColor(
    light: Colors.white,
    dark: Color(0xFF123322),
  );

  static const primaryContainer = AdaptiveColor(
    light: Color(0xFFDCEEE3),
    dark: Color(0xFF234A38),
  );

  static const onPrimaryContainer = AdaptiveColor(
    light: Color(0xFF1F4A34),
    dark: Color(0xFFCFEFDD),
  );

  // Secondary — warm clay accent
  static const secondary = AdaptiveColor(
    light: Color(0xFFC97C4B),
    dark: Color(0xFFD99B6C),
  );

  static const onSecondary = AdaptiveColor(
    light: Colors.white,
    dark: Color(0xFF3B2312),
  );

  static const secondaryContainer = AdaptiveColor(
    light: Color(0xFFF5E3D3),
    dark: Color(0xFF4A2E19),
  );

  static const onSecondaryContainer = AdaptiveColor(
    light: Color(0xFF5C3A1E),
    dark: Color(0xFFF0D8C2),
  );

  // Tertiary — soft slate blue (used for e.g. sleep-type habits)
  static const tertiary = AdaptiveColor(
    light: Color(0xFF4F7EA8),
    dark: Color(0xFF86AFD4),
  );

  static const onTertiary = AdaptiveColor(
    light: Colors.white,
    dark: Color(0xFF12283C),
  );

  static const tertiaryContainer = AdaptiveColor(
    light: Color(0xFFE1EBF5),
    dark: Color(0xFF1F3A54),
  );

  static const onTertiaryContainer = AdaptiveColor(
    light: Color(0xFF1F3A54),
    dark: Color(0xFFD6E6F5),
  );

  // Error — reserved for true errors/destructive actions. Missed-habit
  // states intentionally do NOT use this; they read neutral (see
  // AppColors.neutralMiss) so the app never shames a skipped day.
  static const error = AdaptiveColor(
    light: Color(0xFFC1503D),
    dark: Color(0xFFE0897A),
  );

  static const onError = AdaptiveColor(
    light: Colors.white,
    dark: Color(0xFF4A160D),
  );

  static const errorContainer = AdaptiveColor(
    light: Color(0xFFF6DFDA),
    dark: Color(0xFF5C2318),
  );

  static const onErrorContainer = AdaptiveColor(
    light: Color(0xFF5C2318),
    dark: Color(0xFFF6DFDA),
  );

  /// Neutral tone for missed/incomplete occurrences — deliberately not red.
  static const neutralMiss = AdaptiveColor(
    light: Color(0xFFCCC5B7),
    dark: Color(0xFF4C473F),
  );

  // Surface
  static const surface = AdaptiveColor(
    light: Color(0xFFFDFBF8),
    dark: Color(0xFF34302B),
  );

  static const onSurface = AdaptiveColor(
    light: Color(0xFF2B2620),
    dark: Color(0xFFECE8E2),
  );

  static const onSurfaceVariant = AdaptiveColor(
    light: Color(0xFF6B6459),
    dark: Color(0xFFA9A296),
  );

  // Layered surface tiers - low to high emphasis, for card/dialog/sheet
  // hierarchy so both modes read as soft stacked panels, warm not clinical.
  static const surfaceContainerLowest = AdaptiveColor(
    light: Colors.white,
    dark: Color(0xFF221F1B),
  );

  static const surfaceContainerLow = AdaptiveColor(
    light: Color(0xFFFBF9F5),
    dark: Color(0xFF2C2924),
  );

  static const surfaceContainer = AdaptiveColor(
    light: Color(0xFFF5F2EC),
    dark: Color(0xFF34302B),
  );

  static const surfaceContainerHigh = AdaptiveColor(
    light: Color(0xFFEFEBE3),
    dark: Color(0xFF3D3931),
  );

  static const surfaceContainerHighest = AdaptiveColor(
    light: Color(0xFFE9E4DA),
    dark: Color(0xFF47423A),
  );

  // Background
  static const background = AdaptiveColor(
    light: Color(0xFFF7F5F0),
    dark: Color(0xFF2C2924),
  );

  static const onBackground = AdaptiveColor(
    light: Color(0xFF2B2620),
    dark: Color(0xFFECE8E2),
  );

  // Outlines
  static const outline = AdaptiveColor(
    light: Color(0xFFC9C2B3),
    dark: Color(0xFF6B6459),
  );

  static const outlineVariant = AdaptiveColor(
    light: Color(0xFFE1DCD0),
    dark: Color(0xFF3D3931),
  );

  // Shadow & Scrim
  static const shadow = AdaptiveColor(
    light: Colors.black,
    dark: Colors.black,
  );

  static const scrim = AdaptiveColor(
    light: Colors.black,
    dark: Colors.black,
  );

  // Inverse
  static const inverseSurface = AdaptiveColor(
    light: Color(0xFF2F3137),
    dark: Color(0xFFE6E8EC),
  );

  static const onInverseSurface = AdaptiveColor(
    light: Color(0xFFF4F4F4),
    dark: Color(0xFF121212),
  );

  static const inversePrimary = AdaptiveColor(
    light: Color(0xFFF4C430),
    dark: Color(0xFFF4C430),
  );

  // =========================================================
  // SEMANTIC COLORS - ADAPTIVE
  // =========================================================

  static const success = AdaptiveColor(
    light: Color(0xFF1FA45D),
    dark: Color(0xFF34D399),
  );

  static const onSuccess = AdaptiveColor(
    light: Colors.white,
    dark: Colors.black,
  );

  static const successContainer = AdaptiveColor(
    light: Color(0xFFECF9ED),
    dark: Color(0xFF12472C),
  );

  static const onSuccessContainer = AdaptiveColor(
    light: Color(0xFF0D3B20),
    dark: Color(0xFFECF9ED),
  );

  static const warning = AdaptiveColor(
    light: Color(0xFFB8860B),
    dark: Color(0xFFFBBF24),
  );

  static const onWarning = AdaptiveColor(
    light: Colors.black,
    dark: Colors.black,
  );

  static const warningContainer = AdaptiveColor(
    light: Color(0xFFFFF4CC),
    dark: Color(0xFF4A3A00),
  );

  static const onWarningContainer = AdaptiveColor(
    light: Color(0xFF3D2E00),
    dark: Color(0xFFFFF4CC),
  );

  static const info = AdaptiveColor(
    light: Color(0xFF3B82F6),
    dark: Color(0xFF60A5FA),
  );

  static const onInfo = AdaptiveColor(
    light: Colors.white,
    dark: Colors.black,
  );

  static const infoContainer = AdaptiveColor(
    light: Color(0xFFE6F0FF),
    dark: Color(0xFF1E3A66),
  );

  static const onInfoContainer = AdaptiveColor(
    light: Color(0xFF0A2E5C),
    dark: Color(0xFFE6F0FF),
  );

  // =========================================================
  // COMMON UI COLORS - ADAPTIVE
  // =========================================================

  static const red = AdaptiveColor(
    light: Color(0xFFEF4444),
    dark: Color(0xFFF87171),
  );

  static const orange = AdaptiveColor(
    light: Color(0xFFF97316),
    dark: Color(0xFFFB923C),
  );

  static const yellow = AdaptiveColor(
    light: Color(0xFFEAB308),
    dark: Color(0xFFFACC15),
  );

  static const green = AdaptiveColor(
    light: Color(0xFF22C55E),
    dark: Color(0xFF4ADE80),
  );

  static const blue = AdaptiveColor(
    light: Color(0xFF3B82F6),
    dark: Color(0xFF60A5FA),
  );

  static const purple = AdaptiveColor(
    light: Color(0xFF9333EA),
    dark: Color(0xFFA78BFA),
  );

  static const pink = AdaptiveColor(
    light: Color(0xFFEC4899),
    dark: Color(0xFFF472B6),
  );

  static const cyan = AdaptiveColor(
    light: Color(0xFF06B6D4),
    dark: Color(0xFF22D3EE),
  );

  static const indigo = AdaptiveColor(
    light: Color(0xFF6366F1),
    dark: Color(0xFF818CF8),
  );

  static const emerald = AdaptiveColor(
    light: Color(0xFF10B981),
    dark: Color(0xFF34D399),
  );

  // =========================================================
  // TEXT COLORS - ADAPTIVE
  // =========================================================

  static const text = AdaptiveColor(
    light: Color(0xFF2B2620),
    dark: Color(0xFFECE8E2),
  );

  static const textSecondary = AdaptiveColor(
    light: Color(0xFF6B6459),
    dark: Color(0xFFA9A296),
  );

  static const textTertiary = AdaptiveColor(
    light: Color(0xFF9C9384),
    dark: Color(0xFF7A7468),
  );

  static const textDisabled = AdaptiveColor(
    light: Color(0xFFD6D0C4),
    dark: Color(0xFF554F45),
  );

  // =========================================================
  // BORDER & DIVIDER COLORS - ADAPTIVE
  // =========================================================

  static const border = AdaptiveColor(
    light: Color(0xFFE1DCD0),
    dark: Color(0xFF3D3931),
  );

  static const divider = AdaptiveColor(
    light: Color(0xFFE1DCD0),
    dark: Color(0xFF3D3931),
  );

  // =========================================================
  // SPECIAL PURPOSE COLORS
  // =========================================================

  // Complaint/Report specific colors
  static const complaint = AdaptiveColor(
    light: Color(0xFFEF4444),
    dark: Color(0xFFDC2626),
  );

  static const complaintBackground = AdaptiveColor(
    light: Color(0xFFFFEEF0),
    dark: Color(0xFF2D1517),
  );

  // Hero gradients
  static const heroGradientStart = AdaptiveColor(
    light: Color(0xFF0A1A2F),
    dark: Color(0xFF051029),
  );

  static const heroGradientEnd = AdaptiveColor(
    light: Color(0xFF13263F),
    dark: Color(0xFF0F1B3A),
  );

  // =========================================================
  // STATIC GRADIENT COLORS (for complex gradients)
  // =========================================================

  static const Color cyan50 = Color(0xFFECFEFF);
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color cyan500 = Color(0xFF06B6D4);
  static const Color cyan600 = Color(0xFF0891B2);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);
  static const Color purple500 = Color(0xFF9333EA);
  static const Color purple600 = Color(0xFF7C3AED);
  static const Color pink500 = Color(0xFFEC4899);
  static const Color pink600 = Color(0xFFDB2777);

  // With alpha
  static const Color cyan500Alpha30 = Color(0x4D06B6D4);
  static const Color blue600Alpha30 = Color(0x4D2563EB);
  static const Color purple500Alpha30 = Color(0x4D9333EA);
  static const Color pink500Alpha30 = Color(0x4DEC4899);
  static const Color complaint50 = Color(0xFFFFEEF0);
  static const Color complaint500 = Color(0xFFEF4444);
  static const Color complaint600 = Color(0xFFDC2626);
  static const Color complaint500Alpha20 = Color(0x33EF4444);
  static const Color complaint500Alpha30 = Color(0x4DEF4444);
  static const Color darkHeroStart = Color(0xFF051029);
  static const Color darkHeroEnd = Color(0xFF0F1B3A);

  // Additional static colors for themes
  static const Color lightTertiaryContainer = Color(0xFFFFE7DF);
  static const Color darkTertiaryContainer = Color(0xFF661F0F);
  static const Color darkErrorContainer = Color(0xFF8C1D18);
  static const Color darkSurface = Color(0xFF0F131A);
  static const Color darkBackground = Color(0xFF050A14);
  static const Color indigo500 = Color(0xFF6366F1);
}
