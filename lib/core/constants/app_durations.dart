/// Animation durations untuk consistency di seluruh aplikasi
class AppDurations {
  AppDurations._();

  // ========== STANDARD DURATIONS ==========
  /// Fast: 150ms - Quick interactions
  static const Duration fast = Duration(milliseconds: 150);
  
  /// Normal: 300ms - Standard animations
  static const Duration normal = Duration(milliseconds: 300);
  
  /// Slow: 500ms - Deliberate animations
  static const Duration slow = Duration(milliseconds: 500);

  // ========== SPECIFIC DURATIONS ==========
  /// Splash screen duration
  static const Duration splash = Duration(seconds: 2);
  
  /// Button press feedback
  static const Duration buttonPress = Duration(milliseconds: 100);
  static const Duration buttonRelease = Duration(milliseconds: 200);
  
  /// Ripple effect
  static const Duration ripple = Duration(milliseconds: 300);
  
  /// Toast notification display
  static const Duration toastDisplay = Duration(seconds: 3);
  static const Duration toastEnter = Duration(milliseconds: 400);
  static const Duration toastExit = Duration(milliseconds: 300);
  
  /// Dialog animations
  static const Duration dialogEnter = Duration(milliseconds: 250);
  static const Duration dialogExit = Duration(milliseconds: 200);
  
  /// Bottom sheet animations
  static const Duration bottomSheetEnter = Duration(milliseconds: 350);
  static const Duration bottomSheetExit = Duration(milliseconds: 250);
  
  /// Page transitions
  static const Duration pageTransitionForward = Duration(milliseconds: 300);
  static const Duration pageTransitionBack = Duration(milliseconds: 250);
  
  /// Swipe animations
  static const Duration swipeAnimation = Duration(milliseconds: 200);
  
  /// Shimmer loading effect
  static const Duration shimmer = Duration(milliseconds: 1500);
  
  /// Password strength bar fill
  static const Duration passwordStrengthFill = Duration(milliseconds: 300);
  
  /// Check icon bounce
  static const Duration checkBounce = Duration(milliseconds: 200);
  
  /// Shake animation (error)
  static const Duration shake = Duration(milliseconds: 300);
  static const Duration shakeError = Duration(milliseconds: 400);
  
  /// Fade transitions
  static const Duration fadeIn = Duration(milliseconds: 300);
  static const Duration fadeOut = Duration(milliseconds: 200);
  
  /// Scale animations
  static const Duration scaleIn = Duration(milliseconds: 250);
  static const Duration scaleOut = Duration(milliseconds: 200);
  
  /// Slide animations
  static const Duration slideIn = Duration(milliseconds: 300);
  static const Duration slideOut = Duration(milliseconds: 250);
  
  /// Focus/blur animations
  static const Duration focus = Duration(milliseconds: 200);
  static const Duration blur = Duration(milliseconds: 150);
  
  /// Color transitions
  static const Duration colorChange = Duration(milliseconds: 250);
  
  /// Glow effects
  static const Duration glowPulse = Duration(milliseconds: 1500);
  
  /// Loading spinner rotation
  static const Duration spinnerRotation = Duration(seconds: 1);
  
  /// Lock icon animation (splash)
  static const Duration lockRotation = Duration(seconds: 2);
  
  /// Background gradient shift
  static const Duration backgroundShift = Duration(seconds: 4);
  
  /// FAB pulse animation
  static const Duration fabPulse = Duration(seconds: 2);
  
  /// Auto-save debounce
  static const Duration autoSaveDebounce = Duration(milliseconds: 500);
  
  /// Search debounce
  static const Duration searchDebounce = Duration(milliseconds: 500);
  
  /// Scroll animation
  static const Duration scrollAnimation = Duration(milliseconds: 300);
  
  /// Keyboard animation
  static const Duration keyboardAnimation = Duration(milliseconds: 300);
  
  /// Menu item stagger delay
  static const Duration menuItemStagger = Duration(milliseconds: 50);
  
  /// Card hover animation
  static const Duration cardHover = Duration(milliseconds: 200);
  
  /// Icon animation
  static const Duration iconAnimation = Duration(milliseconds: 200);
  
  /// Tab change animation
  static const Duration tabChange = Duration(milliseconds: 300);
  
  /// Expansion animation
  static const Duration expansion = Duration(milliseconds: 300);
  
  /// Collapse animation
  static const Duration collapse = Duration(milliseconds: 250);
  
  /// Progress bar animation
  static const Duration progressBar = Duration(milliseconds: 400);
  
  /// Countdown timer
  static const Duration countdownTick = Duration(seconds: 1);
  
  /// Snackbar duration
  static const Duration snackbar = Duration(seconds: 4);
  
  /// Tooltip delay
  static const Duration tooltipDelay = Duration(milliseconds: 500);
  
  /// Long press delay
  static const Duration longPressDelay = Duration(milliseconds: 500);
  
  /// Double tap window
  static const Duration doubleTapWindow = Duration(milliseconds: 300);

  // ========== DELAYS ==========
  /// Short delay for staggered animations
  static const Duration delayShort = Duration(milliseconds: 50);
  
  /// Medium delay
  static const Duration delayMedium = Duration(milliseconds: 100);
  
  /// Long delay
  static const Duration delayLong = Duration(milliseconds: 200);
}
