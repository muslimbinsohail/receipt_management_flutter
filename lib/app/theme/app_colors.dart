import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF9B8FEF);
  static const Color primaryDark = Color(0xFF4A3FC7);

  // Secondary
  static const Color secondary = Color(0xFF00CEC9);
  static const Color secondaryLight = Color(0xFF55EFC4);
  static const Color secondaryDark = Color(0xFF009E99);

  // Accent
  static const Color accent = Color(0xFFFD79A8);
  static const Color accentLight = Color(0xFFFF9DBF);
  static const Color accentDark = Color(0xFFE84393);

  // Neutral
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F1F6);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Dark Theme
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceVariant = Color(0xFF21262D);
  static const Color darkCardBackground = Color(0xFF1C2128);

  // Text
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textTertiary = Color(0xFFB2BEC3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Dark Text
  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  static const Color darkTextSecondary = Color(0xFF8B949E);
  static const Color darkTextTertiary = Color(0xFF484F58);

  // Status
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDAA5B);
  static const Color error = Color(0xFFE17055);
  static const Color info = Color(0xFF74B9FF);

  // Sync Status
  static const Color synced = Color(0xFF00B894);
  static const Color pending = Color(0xFFFDAA5B);
  static const Color syncFailed = Color(0xFFE17055);
  static const Color conflict = Color(0xFFE84393);

  // Receipt Template Colors
  static const Color modernMinimalAccent = Color(0xFF6C5CE7);
  static const Color classicFormalAccent = Color(0xFF2C3E50);
  static const Color boldColorfulAccent = Color(0xFFE17055);
  static const Color darkPremiumGold = Color(0xFFD4A574);
  static const Color vintageSepia = Color(0xFF8B7355);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF8E7CF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFA29BFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBackground, Color(0xFF1A1F2B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Divider & Border
  static const Color divider = Color(0xFFE8EAED);
  static const Color darkDivider = Color(0xFF30363D);
  static const Color border = Color(0xFFDDD6F3);
  static const Color darkBorder = Color(0xFF30363D);

  // Shadows
  static const Color shadowLight = Color(0x1A6C5CE7);
  static const Color shadowDark = Color(0x40000000);
}
