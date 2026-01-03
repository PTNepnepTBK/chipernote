/// Spacing, border radius, sizes dalam konstanta (8pt Grid System)
class AppDimensions {
  AppDimensions._();

  // ========== SPACING SYSTEM (8pt Grid) ==========
  /// xs: 4px - Minimal spacing, icon padding
  static const double spacingXs = 4.0;
  
  /// sm: 8px - Compact elements
  static const double spacingSm = 8.0;
  
  /// md: 16px - Standard padding
  static const double spacingMd = 16.0;
  
  /// lg: 24px - Section spacing
  static const double spacingLg = 24.0;
  
  /// xl: 32px - Major sections
  static const double spacingXl = 32.0;
  
  /// 2xl: 48px - Page margins
  static const double spacing2xl = 48.0;
  
  /// 3xl: 64px - Large gaps
  static const double spacing3xl = 64.0;

  // ========== BORDER RADIUS ==========
  /// Small: 8px - Buttons, chips, tags
  static const double radiusSmall = 8.0;
  
  /// Medium: 12px - Cards, inputs
  static const double radiusMedium = 12.0;
  
  /// Large: 16px - Modals, bottom sheets
  static const double radiusLarge = 16.0;
  
  /// XLarge: 24px - Major containers
  static const double radiusXLarge = 24.0;
  
  /// Full: 9999px - Circular elements (FAB, avatars)
  static const double radiusFull = 9999.0;

  // ========== COMPONENT SIZES ==========
  /// Icon size standard
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  
  /// Button heights
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;
  
  /// Input field heights
  static const double inputHeightStandard = 56.0;
  static const double inputHeightCompact = 48.0;
  
  /// AppBar height
  static const double appBarHeight = 64.0;
  
  /// Bottom navigation height
  static const double bottomNavHeight = 72.0;
  
  /// FAB size
  static const double fabSize = 64.0;
  static const double fabSizeSmall = 56.0;
  
  /// Card minimum height
  static const double cardMinHeight = 120.0;
  
  /// Dialog width
  static const double dialogWidth = 320.0;
  static const double dialogMaxWidth = 600.0;
  
  /// Bottom sheet drag handle
  static const double dragHandleWidth = 40.0;
  static const double dragHandleHeight = 4.0;
  
  /// Custom keyboard height
  static const double keyboardHeight = 280.0;
  
  /// Filter chips height
  static const double filterChipsHeight = 52.0;

  // ========== TOUCH TARGETS ==========
  /// Minimum touch target size (accessibility)
  static const double minTouchTarget = 48.0;
  
  /// Comfortable touch target
  static const double touchTargetComfortable = 56.0;

  // ========== ELEVATION SHADOWS ==========
  /// Shadow blur radius untuk berbagai elevasi
  static const double shadowBlur1 = 8.0;
  static const double shadowBlur2 = 16.0;
  static const double shadowBlur3 = 24.0;
  static const double shadowBlur4 = 32.0;
  
  /// Shadow offset Y
  static const double shadowOffsetY1 = 2.0;
  static const double shadowOffsetY2 = 4.0;
  static const double shadowOffsetY3 = 8.0;
  static const double shadowOffsetY4 = 12.0;

  // ========== GRID & LIST ==========
  /// Masonry grid columns
  static const int gridColumns = 2;
  static const int gridColumnsTablet = 3;
  static const int gridColumnsDesktop = 4;
  
  /// Grid gap
  static const double gridGap = 12.0;
  
  /// List item height
  static const double listItemHeight = 72.0;
  static const double listItemHeightCompact = 56.0;

  // ========== BORDERS ==========
  /// Border widths
  static const double borderThin = 1.0;
  static const double borderMedium = 2.0;
  static const double borderThick = 4.0;

  // ========== SPECIAL SIZES ==========
  /// Logo size untuk splash screen
  static const double logoSizeSplash = 120.0;
  
  /// Illustration size untuk onboarding
  static const double illustrationWidth = 280.0;
  static const double illustrationHeight = 240.0;
  
  /// Empty state illustration
  static const double emptyStateIllustration = 200.0;
  
  /// Password strength bar height
  static const double passwordStrengthBarHeight = 4.0;
  
  /// Progress indicator size
  static const double progressIndicatorSmall = 8.0;
  static const double progressIndicatorMedium = 12.0;
  static const double progressIndicatorLarge = 40.0;

  // ========== ANIMATION OFFSETS ==========
  /// Parallax offset
  static const double parallaxOffset = 20.0;
  
  /// Swipe threshold
  static const double swipeThreshold = 100.0;
  
  /// Scale animation values
  static const double scaleMin = 0.95;
  static const double scaleNormal = 1.0;
  static const double scaleMax = 1.05;
  static const double scaleBounce = 1.2;

  // ========== RESPONSIVE BREAKPOINTS ==========
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 1024.0;
  static const double breakpointDesktop = 1440.0;
}
