import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Newsreader (serif) for display/headline — the calm, editorial voice for
/// "Today", habit names, big numbers. Manrope (sans) for everything else.
class AppTextTheme {
  static const TextTheme _base = TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w500, letterSpacing: -0.25, height: 64 / 57),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w500, height: 52 / 45),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, height: 44 / 36),

    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, height: 40 / 32),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, height: 36 / 28),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 32 / 24),

    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 26 / 20),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.1, height: 24 / 16),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, height: 20 / 14),

    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.1, height: 20 / 14),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.3, height: 16 / 12),
    labelSmall: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 0.4, height: 16 / 11.5),

    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.1, height: 24 / 16),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1, height: 20 / 14),
    bodySmall: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w400, letterSpacing: 0.1, height: 16 / 12.5),
  );

  static final TextTheme lightTextTheme = _compose();
  static final TextTheme darkTextTheme = _compose();

  static TextTheme _compose() {
    final sans = GoogleFonts.manropeTextTheme(_base);
    final serif = GoogleFonts.newsreaderTextTheme(_base);
    return sans.copyWith(
      displayLarge: serif.displayLarge,
      displayMedium: serif.displayMedium,
      displaySmall: serif.displaySmall,
      headlineLarge: serif.headlineLarge,
      headlineMedium: serif.headlineMedium,
      headlineSmall: serif.headlineSmall,
    );
  }
}
