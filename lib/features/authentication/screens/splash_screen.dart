import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/auth_service.dart';
import 'onboarding_screen.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _rotationController;
  late AnimationController _glowController;
  late AnimationController _gradientController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;
  late Animation<Offset> _gradientAnimation;

  @override
  void initState() {
    super.initState();

    // Fade and scale animation for logo
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // Rotation animation for lock icon
    _rotationController = AnimationController(
      duration: AppDurations.lockRotation,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: -5 * math.pi / 180, end: 5 * math.pi / 180)
        .animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );

    // Glow pulse animation
    _glowController = AnimationController(
      duration: AppDurations.glowPulse,
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Background gradient shift animation
    _gradientController = AnimationController(
      duration: AppDurations.backgroundShift,
      vsync: this,
    );

    _gradientAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, AppDimensions.parallaxOffset),
    ).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _rotationController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
    _gradientController.repeat(reverse: true);

    // Navigate after checking app state
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(AppDurations.splash);

    if (!mounted) return;

    final dbService = DatabaseService();
    final authService = AuthService();

    // Initialize auth service
    await authService.initialize();

    // Check if onboarding has been completed
    final hasCompletedOnboarding = await dbService.hasCompletedOnboarding();

    // Check if master password has been set
    final hasMasterPassword = await authService.hasMasterPassword();

    Widget nextScreen;

    if (!hasCompletedOnboarding) {
      // First time user - show onboarding
      nextScreen = const OnboardingScreen();
    } else if (!hasMasterPassword) {
      // Onboarding done but no password set - shouldn't happen, but go to onboarding
      nextScreen = const OnboardingScreen();
    } else {
      // User has completed setup - show authentication screen
      nextScreen = const AuthScreen();
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: AppDurations.fadeIn,
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundPrimary,
                  AppColors.primaryMain,
                ],
                stops: [
                  0.0 + (_gradientAnimation.value.dy / 1000),
                  1.0 + (_gradientAnimation.value.dy / 1000),
                ],
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with glow and rotation
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _rotationAnimation,
                      _glowAnimation,
                    ]),
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                            color: AppColors.secondaryMain.withValues(
                              alpha: _glowAnimation.value,
                              ),
                              blurRadius: 40,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.lock_rounded,
                      size: AppDimensions.logoSizeSplash,
                      color: AppColors.secondaryMain,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingLg),
                  // App name
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.displayLarge,
                  ),
                  SizedBox(height: AppDimensions.spacingSm),
                  // Tagline
                  Text(
                    AppStrings.appTagline,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
