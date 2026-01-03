import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import 'color_schemes.dart';

/// ThemeData configuration untuk dark dan light mode
class AppTheme {
  AppTheme._();

  /// Dark Theme (Default)
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: AppColorSchemes.dark,
        textTheme: AppTextTheme.textTheme,
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        
        // AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryMain,
          foregroundColor: AppColors.textPrimary,
          elevation: 4,
          shadowColor: AppColors.shadow2,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: AppTextTheme.textTheme.titleLarge,
          toolbarHeight: AppDimensions.appBarHeight,
        ),

        // Card Theme
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shadowColor: AppColors.shadow1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          margin: EdgeInsets.zero,
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryMain,
            foregroundColor: AppColors.textPrimary,
            elevation: 4,
            shadowColor: AppColors.shadow2,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
              vertical: AppDimensions.spacingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            textStyle: AppTextTheme.textTheme.labelLarge,
            minimumSize: Size(0, AppDimensions.buttonHeightMedium),
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondaryMain,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
              vertical: AppDimensions.spacingSm,
            ),
            textStyle: AppTextTheme.textTheme.labelLarge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
          ),
        ),

        // Outlined Button Theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: BorderSide(color: AppColors.divider),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
              vertical: AppDimensions.spacingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            textStyle: AppTextTheme.textTheme.labelLarge,
            minimumSize: Size(0, AppDimensions.buttonHeightMedium),
          ),
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.secondaryMain,
          foregroundColor: AppColors.textPrimary,
          elevation: 8,
          shape: CircleBorder(),
          iconSize: AppDimensions.iconSizeLarge,
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMd,
            vertical: AppDimensions.spacingMd,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide(color: AppColors.secondaryMain, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide(color: AppColors.danger),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            borderSide: BorderSide(color: AppColors.danger, width: 2),
          ),
          labelStyle: AppTextTheme.textTheme.bodyMedium,
          hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textDisabled,
          ),
          errorStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
            color: AppColors.danger,
          ),
          prefixIconColor: AppColors.textSecondary,
          suffixIconColor: AppColors.textSecondary,
        ),

        // Dialog Theme
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.surface,
          elevation: 16,
          shadowColor: AppColors.shadow4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          titleTextStyle: AppTextTheme.textTheme.headlineMedium,
          contentTextStyle: AppTextTheme.textTheme.bodyMedium,
        ),

        // Bottom Sheet Theme
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.primaryMain,
          elevation: 16,
          shadowColor: AppColors.shadow4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusLarge),
            ),
          ),
          modalBackgroundColor: AppColors.primaryMain,
          modalElevation: 16,
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surface,
          selectedColor: AppColors.secondaryMain,
          disabledColor: AppColors.surface.withValues(alpha: 0.5),
          labelStyle: AppTextTheme.textTheme.labelMedium,
          secondaryLabelStyle: AppTextTheme.textTheme.labelMedium,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingSm,
            vertical: AppDimensions.spacingXs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
        ),

        // Switch Theme
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.textPrimary;
            }
            return AppColors.textDisabled;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.secondaryMain;
            }
            return AppColors.divider;
          }),
        ),

        // Checkbox Theme
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.secondaryMain;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AppColors.textPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        // Radio Theme
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.secondaryMain;
            }
            return AppColors.textSecondary;
          }),
        ),

        // Slider Theme
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.secondaryMain,
          inactiveTrackColor: AppColors.divider,
          thumbColor: AppColors.secondaryMain,
          overlayColor: AppColors.secondaryMain.withValues(alpha: 0.2),
        ),

        // Progress Indicator Theme
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.secondaryMain,
          linearTrackColor: AppColors.divider,
          circularTrackColor: AppColors.divider,
        ),

        // Divider Theme
        dividerTheme: DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),

        // Icon Theme
        iconTheme: IconThemeData(
          color: AppColors.textSecondary,
          size: AppDimensions.iconSizeMedium,
        ),

        // List Tile Theme
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMd,
            vertical: AppDimensions.spacingSm,
          ),
          iconColor: AppColors.textSecondary,
          textColor: AppColors.textPrimary,
          tileColor: Colors.transparent,
          selectedTileColor: AppColors.secondaryMain.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
        ),

        // Tooltip Theme
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          textStyle: AppTextTheme.textTheme.bodySmall,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingSm,
            vertical: AppDimensions.spacingXs,
          ),
        ),

        // Snackbar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surface,
          contentTextStyle: AppTextTheme.textTheme.bodyMedium,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),

        // Navigation Bar Theme
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.primaryMain,
          indicatorColor: AppColors.secondaryMain.withValues(alpha: 0.2),
          height: AppDimensions.bottomNavHeight,
          labelTextStyle: WidgetStateProperty.all(
            AppTextTheme.textTheme.labelSmall,
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: AppColors.secondaryMain,
                size: AppDimensions.iconSizeMedium,
              );
            }
            return IconThemeData(
              color: AppColors.textDisabled,
              size: AppDimensions.iconSizeMedium,
            );
          }),
        ),

        // Tab Bar Theme
        tabBarTheme: TabBarThemeData(
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTextTheme.textTheme.labelLarge,
          unselectedLabelStyle: AppTextTheme.textTheme.labelLarge,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: AppColors.secondaryMain,
              width: 4,
            ),
          ),
        ),

        // Splash color
        splashColor: AppColors.ripple,
        highlightColor: AppColors.secondaryMain.withValues(alpha: 0.1),

        // Material tap target size
        materialTapTargetSize: MaterialTapTargetSize.padded,

        // Visual density
        visualDensity: VisualDensity.standard,
      );

  /// Light Theme (Optional)
  static ThemeData get lightTheme => darkTheme.copyWith(
        colorScheme: AppColorSchemes.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: darkTheme.appBarTheme.copyWith(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0A0E27),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        cardTheme: darkTheme.cardTheme.copyWith(
          color: Colors.white,
        ),
        inputDecorationTheme: darkTheme.inputDecorationTheme.copyWith(
          fillColor: Colors.white,
        ),
        dialogTheme: darkTheme.dialogTheme.copyWith(
          backgroundColor: Colors.white,
        ),
      );
}
