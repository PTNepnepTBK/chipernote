import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography definitions untuk aplikasi SecureNotes
/// Font Family: Inter (Primary), JetBrains Mono (Monospace)
class AppTextStyles {
  AppTextStyles._();

  // ========== FONT FAMILIES ==========
  static const String fontFamilyPrimary = 'Inter';
  static const String fontFamilyMonospace = 'JetBrains Mono';
  static const String fontFamilyArabic = 'Noto Sans Arabic';

  // ========== DISPLAY STYLES ==========
  /// Display Large: 57px, Weight 700 - Untuk splash screen
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 64 / 57,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
  );

  // ========== HEADLINE STYLES ==========
  /// Headline Large: 32px, Weight 600 - Page titles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  /// Headline Medium: 28px, Weight 600 - Section headers
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  // ========== TITLE STYLES ==========
  /// Title Large: 22px, Weight 500 - Card titles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 28 / 22,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  /// Title Medium: 16px, Weight 500 - List items
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
  );

  // ========== BODY STYLES ==========
  /// Body Large: 16px, Weight 400 - Main content
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  /// Body Medium: 14px, Weight 400 - Secondary text
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textSecondary,
    letterSpacing: 0.25,
  );

  /// Body Small: 12px, Weight 400 - Tertiary text
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
  );

  // ========== LABEL STYLES ==========
  /// Label Large: 14px, Weight 500 - Buttons
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  /// Label Medium: 12px, Weight 500 - Small buttons
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  /// Label Small: 11px, Weight 500 - Captions
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // ========== MONOSPACE STYLES ==========
  /// Monospace untuk passwords, codes, technical info
  static const TextStyle monospace = TextStyle(
    fontFamily: fontFamilyMonospace,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle monospaceLarge = TextStyle(
    fontFamily: fontFamilyMonospace,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  // ========== EDITOR STYLES ==========
  /// Editor content dengan line height tinggi untuk readability
  static const TextStyle editorContent = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.8,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  // ========== UTILITY METHODS ==========
  /// Apply color to text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply weight to text style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Apply size to text style
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
