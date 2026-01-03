import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';

/// ColorScheme definitions untuk dark dan light mode
class AppColorSchemes {
  AppColorSchemes._();

  /// Dark Color Scheme (Default)
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryMain,
    onPrimary: AppColors.textPrimary,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.textPrimary,
    secondary: AppColors.secondaryMain,
    onSecondary: AppColors.textPrimary,
    secondaryContainer: AppColors.secondaryDark,
    onSecondaryContainer: AppColors.textPrimary,
    tertiary: AppColors.info,
    onTertiary: AppColors.textPrimary,
    error: AppColors.danger,
    onError: AppColors.textPrimary,
    errorContainer: AppColors.danger,
    onErrorContainer: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.divider,
    outlineVariant: AppColors.divider,
    shadow: Colors.black,
    scrim: Colors.black54,
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.backgroundPrimary,
    inversePrimary: AppColors.primaryLight,
    surfaceTint: AppColors.secondaryMain,
  );

  /// Light Color Scheme (Optional)
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryMain,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondaryMain,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.secondaryLight,
    onSecondaryContainer: AppColors.secondaryDark,
    tertiary: AppColors.info,
    onTertiary: Colors.white,
    error: AppColors.danger,
    onError: Colors.white,
    errorContainer: Color(0xFFFDEDED),
    onErrorContainer: AppColors.danger,
    surface: Colors.white,
    onSurface: Color(0xFF0A0E27),
    onSurfaceVariant: Color(0xFF6B7280),
    outline: Color(0xFFE0E0E0),
    outlineVariant: Color(0xFFF5F7FA),
    shadow: Colors.black26,
    scrim: Colors.black54,
    inverseSurface: Color(0xFF0A0E27),
    onInverseSurface: Colors.white,
    inversePrimary: AppColors.secondaryLight,
    surfaceTint: AppColors.secondaryMain,
  );
}

/// TextTheme dengan font families yang sesuai
class AppTextTheme {
  AppTextTheme._();

  static TextTheme get textTheme => TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      );
}

/// Shadow definitions untuk berbagai elevasi
class AppShadows {
  AppShadows._();

  /// Level 1 (Cards)
  static List<BoxShadow> get level1 => [
        BoxShadow(
          color: AppColors.shadow1,
          blurRadius: AppDimensions.shadowBlur1,
          offset: Offset(0, AppDimensions.shadowOffsetY1),
        ),
      ];

  /// Level 2 (Floating buttons)
  static List<BoxShadow> get level2 => [
        BoxShadow(
          color: AppColors.shadow2,
          blurRadius: AppDimensions.shadowBlur2,
          offset: Offset(0, AppDimensions.shadowOffsetY2),
        ),
      ];

  /// Level 3 (Modals)
  static List<BoxShadow> get level3 => [
        BoxShadow(
          color: AppColors.shadow3,
          blurRadius: AppDimensions.shadowBlur3,
          offset: Offset(0, AppDimensions.shadowOffsetY3),
        ),
      ];

  /// Level 4 (Dialogs)
  static List<BoxShadow> get level4 => [
        BoxShadow(
          color: AppColors.shadow4,
          blurRadius: AppDimensions.shadowBlur4,
          offset: Offset(0, AppDimensions.shadowOffsetY4),
        ),
      ];

  /// Inverted shadow (untuk bottom navigation)
  static List<BoxShadow> get levelInverted => [
        BoxShadow(
          color: AppColors.shadow2,
          blurRadius: AppDimensions.shadowBlur2,
          offset: Offset(0, -AppDimensions.shadowOffsetY2),
        ),
      ];

  /// Glow effect (cyan)
  static List<BoxShadow> glowCyan({double opacity = 0.4}) => [
        BoxShadow(
          color: AppColors.secondaryMain.withValues(alpha: opacity),
          blurRadius: 40.0,
          spreadRadius: 0,
        ),
      ];

  /// Glow effect (custom color)
  static List<BoxShadow> glowCustom(Color color, {double opacity = 0.4}) => [
        BoxShadow(
          color: color.withValues(alpha: opacity),
          blurRadius: 40.0,
          spreadRadius: 0,
        ),
      ];
}
