import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/services/database_service.dart';
import 'setup_password_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.security_rounded,
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
    ),
    OnboardingData(
      icon: Icons.keyboard_alt_rounded,
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
    ),
    OnboardingData(
      icon: Icons.visibility_off_rounded,
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _navigateToSetup() async {
    // Mark onboarding as completed in database
    final dbService = DatabaseService();
    await dbService.setOnboardingCompleted();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SetupPasswordScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: AppDurations.pageTransitionForward,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: _pages[index],
                    pageController: _pageController,
                    pageIndex: index,
                  );
                },
              ),
            ),
            // Progress indicators
            Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.spacingXl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: AppDurations.normal,
                    margin: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingXs,
                    ),
                    width: _currentPage == index
                        ? AppDimensions.progressIndicatorMedium
                        : AppDimensions.progressIndicatorSmall,
                    height: _currentPage == index
                        ? AppDimensions.progressIndicatorMedium
                        : AppDimensions.progressIndicatorSmall,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppColors.secondaryMain
                          : AppColors.divider,
                    ),
                  ),
                ),
              ),
            ),
            // Get Started button (visible on last page)
            if (_currentPage == _pages.length - 1)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.spacingLg,
                  0,
                  AppDimensions.spacingLg,
                  AppDimensions.spacing2xl,
                ),
                child: CustomButton(
                  text: AppStrings.getStarted,
                  onPressed: _navigateToSetup,
                  isFullWidth: true,
                  size: CustomButtonSize.large,
                  gradient: AppColors.buttonGradient,
                ),
              )
            else
              SizedBox(height: AppDimensions.spacing2xl + 56),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final PageController pageController;
  final int pageIndex;

  const OnboardingPage({
    Key? key,
    required this.data,
    required this.pageController,
    required this.pageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 80),
          // Illustration
          TweenAnimationBuilder<double>(
            duration: AppDurations.slow,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              width: AppDimensions.illustrationWidth,
              height: AppDimensions.illustrationHeight,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondaryMain.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                data.icon,
                size: 120,
                color: AppColors.secondaryMain,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacingXl),
          // Title
          TweenAnimationBuilder<double>(
            duration: AppDurations.slow,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Text(
              data.title,
              style: AppTextStyles.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppDimensions.spacingMd),
          // Description
          TweenAnimationBuilder<double>(
            duration: AppDurations.slow,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Text(
              data.description,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
