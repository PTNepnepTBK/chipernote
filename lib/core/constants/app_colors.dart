import 'package:flutter/material.dart';

/// Definisi semua warna aplikasi SecureNotes
/// Menggunakan Deep Blue Security Theme dengan Cyan Accent
class AppColors {
  AppColors._();

  // ========== PRIMARY COLORS - Deep Blue Security Theme ==========
  /// Primary Main: Indigo 900 - Melambangkan keamanan dan kepercayaan
  static const Color primaryMain = Color(0xFF1A237E);
  
  /// Primary Light: Indigo 400 - Untuk hover states dan accents
  static const Color primaryLight = Color(0xFF534BAE);
  
  /// Primary Dark - Untuk shadows dan depth
  static const Color primaryDark = Color(0xFF000051);

  // ========== SECONDARY COLORS - Cyan Accent ==========
  /// Secondary Main: Cyan 500 - Untuk actions dan highlights
  static const Color secondaryMain = Color(0xFF00BCD4);
  
  /// Secondary Light - Untuk backgrounds dan subtle accents
  static const Color secondaryLight = Color(0xFF62EFFF);
  
  /// Secondary Dark - Untuk pressed states
  static const Color secondaryDark = Color(0xFF008BA3);

  // ========== FUNCTIONAL COLORS ==========
  /// Success: Green 500 - Operasi berhasil, enkripsi aktif
  static const Color success = Color(0xFF4CAF50);
  
  /// Danger: Red 500 - Peringatan, penghapusan, error
  static const Color danger = Color(0xFFF44336);
  
  /// Warning: Orange 500 - Perhatian, password lemah
  static const Color warning = Color(0xFFFF9800);
  
  /// Info: Blue 500 - Informasi netral, tips keamanan
  static const Color info = Color(0xFF2196F3);

  // ========== NEUTRAL COLORS - Dark Mode Default ==========
  /// Background Primary: Dark navy - untuk dark mode default
  static const Color backgroundPrimary = Color(0xFF0A0E27);
  
  /// Background Secondary: Slightly lighter navy
  static const Color backgroundSecondary = Color(0xFF1A1F3A);
  
  /// Surface: Card backgrounds
  static const Color surface = Color(0xFF252B48);
  
  /// Text Primary: Pure white untuk readability
  static const Color textPrimary = Color(0xFFFFFFFF);
  
  /// Text Secondary: Muted blue-gray
  static const Color textSecondary = Color(0xFFB0B8D4);
  
  /// Text Disabled: Gray
  static const Color textDisabled = Color(0xFF6B7280);
  
  /// Divider: Subtle separators
  static const Color divider = Color(0xFF2D3348);

  // ========== GRADIENT COLORS ==========
  /// Header Gradient: Top color
  static const Color headerGradientStart = primaryMain;
  
  /// Header Gradient: Bottom color
  static const Color headerGradientEnd = backgroundPrimary;
  
  /// Button Gradient: Start color
  static const Color buttonGradientStart = secondaryMain;
  
  /// Button Gradient: End color
  static const Color buttonGradientEnd = Color(0xFF0097A7);

  // ========== CATEGORY COLORS ==========
  static const Color categoryPurple = Color(0xFF9C27B0);
  static const Color categoryOrange = Color(0xFFFF9800);
  static const Color categoryGreen = Color(0xFF4CAF50);
  static const Color categoryCyan = Color(0xFF00BCD4);
  static const Color categoryPink = Color(0xFFE91E63);

  // ========== SPECIAL COLORS ==========
  /// Lock indicator color untuk password-protected notes
  static const Color lockIndicator = Color(0xFFFFB300);
  
  /// Overlay untuk screen protection
  static const Color protectionOverlay = Color(0xFF000000);
  
  /// Ripple effect color
  static const Color ripple = Color(0x33FFFFFF);

  // ========== GRADIENTS ==========
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [headerGradientStart, headerGradientEnd],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [buttonGradientStart, buttonGradientEnd],
  );

  static const RadialGradient successGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [success, Color(0x00_4CAF50)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundPrimary, primaryMain],
  );

  // ========== SHADOW COLORS ==========
  static Color shadow1 = const Color(0x00000000).withValues(alpha: 0.08);
  static Color shadow2 = const Color(0x00000000).withValues(alpha: 0.12);
  static Color shadow3 = const Color(0x00000000).withValues(alpha: 0.16);
  static Color shadow4 = const Color(0x00000000).withValues(alpha: 0.20);

  // ========== SHIMMER COLORS ==========
  static const Color shimmerBase = Color(0xFF2D3348);
  static const Color shimmerHighlight = Color(0xFF3D4358);
}
