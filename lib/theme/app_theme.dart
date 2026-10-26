import 'package:flutter/material.dart';

/// The Flash News palette, taken from the website so the app and the site
/// look like the same product.
///
///   rose-700  #BE123C  the single accent - buttons, active chips, the FLASH pill
///   slate-50  #F8FAFC  page background (light)
///   slate-900 #0F172A  headline text (light) / page background (dark)
///   slate-600 #475569  body text
///   slate-200 #E2E8F0  card borders
class AppColors {
  const AppColors._();

  static const Color accent = Color(0xFFBE123C);
  static const Color accentDark = Color(0xFF9F1239);
  static const Color accentSoft = Color(0xFFFFE4E6);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextStrong = Color(0xFF0F172A);
  static const Color lightTextMuted = Color(0xFF475569);
  static const Color lightTextFaint = Color(0xFF64748B);

  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkSurface = Color(0xFF171A21);
  static const Color darkBorder = Color(0xFF272C36);
  static const Color darkTextStrong = Color(0xFFE8EAED);
  static const Color darkTextMuted = Color(0xFFA2A9B4);
  static const Color darkTextFaint = Color(0xFF8A919C);
}

class AppTheme {
  const AppTheme._();

  static const double cardRadius = 14;

  static ThemeData light() => _build(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        border: AppColors.lightBorder,
        textStrong: AppColors.lightTextStrong,
        textMuted: AppColors.lightTextMuted,
        textFaint: AppColors.lightTextFaint,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        border: AppColors.darkBorder,
        textStrong: AppColors.darkTextStrong,
        textMuted: AppColors.darkTextMuted,
        textFaint: AppColors.darkTextFaint,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color border,
    required Color textStrong,
    required Color textMuted,
    required Color textFaint,
  }) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.accent,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      dividerColor: border,

      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textStrong,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textStrong,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(color: border),
        ),
      ),

      textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: textStrong,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleMedium: TextStyle(
          color: textStrong,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        titleSmall: TextStyle(
          color: textStrong,
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        bodyMedium: TextStyle(color: textMuted, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: textFaint, fontSize: 12.5, height: 1.4),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: textFaint, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.6),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textStrong,
          minimumSize: const Size(0, 48),
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
      ),
    );
  }
}
