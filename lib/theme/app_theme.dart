import 'package:flutter/material.dart';

/// CityPulse color palette.
/// Sourced from the shared 10-step graphite → champagne palette.
class AppColors {
  AppColors._();

  static const Color deepNavy = Color(0xFF0B0D10);
  static const Color midnightBlue = Color(0xFF14171C);
  static const Color oceanDepth = Color(0xFF1C2027);
  static const Color stormBlue = Color(0xFF2A2F38);
  static const Color blueSlate = Color(0xFFC9A96A);
  static const Color duskBlue = Color(0xFF9AA1AC);
  static const Color foggyBlue = Color(0xFF6B7280);
  static const Color cloudBlue = Color(0xFF2E333C);
  static const Color mistBlue = Color(0xFF1A1D23);
  static const Color arcticHaze = Color(0xFF0B0D10);

  // Semantic roles
  static const Color background = arcticHaze;
  static const Color surface = midnightBlue;
  static const Color primary = blueSlate;
  static const Color primaryDark = Color(0xFFB08D4F);
  static const Color accent = blueSlate;
  static const Color textPrimary = Color(0xFFF3F1EC);
  static const Color textSecondary = duskBlue;
  static const Color border = Color(0xFF2E333C);

  // Status colors
  static const Color normalBg = Color(0xFF16261E);
  static const Color normalFg = Color(0xFF6FCF97);
  static const Color alertBg = Color(0xFF2C1B18);
  static const Color alertFg = Color(0xFFE0876A);
  static const Color errorBg = Color(0xFF2C1B18);
  static const Color errorFg = Color(0xFFE0876A);
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 6;
  static const double sm = 12;
  static const double md = 20;
  static const double lg = 32;
  static const double xl = 48;
}

class AppRadius {
  AppRadius._();

  static const double card = 20;
  static const double control = 14;
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.deepNavy,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.errorFg,
    ),
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Roboto',
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      headlineMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 28,
        letterSpacing: -0.3,
        height: 1.2,
      ),
      titleMedium: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
        letterSpacing: 0.1,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 15,
        height: 1.5,
      ),
      bodySmall: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        letterSpacing: 0.2,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.deepNavy,
        disabledBackgroundColor: AppColors.stormBlue,
        disabledForegroundColor: AppColors.duskBlue,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: const TextStyle(color: AppColors.foggyBlue),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.control),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.control),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.control),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
  );
}
