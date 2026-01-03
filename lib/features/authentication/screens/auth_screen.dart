import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/services/auth_service.dart';
import '../../notes/screens/notes_list_screen.dart';

/// Authentication screen for unlocking the app
/// Supports MULTIPLE ways to access the ONE encryption key:
/// 1. Master password
/// 2. Biometric authentication (if enabled)
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  String _biometricTypeName = 'Biometric';
  String? _errorText;
  
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: AppDurations.shake,
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _checkBiometricStatus();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricStatus() async {
    final enabled = await _authService.isBiometricEnabled();
    final available = await _authService.isBiometricAvailable();
    final typeName = await _authService.getBiometricTypeName();
    
    print('=== Biometric Status ===');
    print('Enabled in settings: $enabled');
    print('Available on device: $available');
    print('Type: $typeName');
    
    if (mounted) {
      setState(() {
        _biometricEnabled = enabled;
        _biometricAvailable = available;
        _biometricTypeName = typeName;
      });

      // Auto-trigger biometric if enabled and available
      if (_biometricEnabled && _biometricAvailable) {
        print('Auto-triggering biometric authentication...');
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _authenticateWithBiometric();
          }
        });
      } else {
        print('Biometric not auto-triggered: enabled=$enabled, available=$available');
      }
    }
  }

  Future<void> _authenticateWithPassword() async {
    setState(() {
      _errorText = null;
    });

    final password = _passwordController.text;

    if (password.isEmpty) {
      _showError('Please enter your password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authenticated = await _authService.authenticateWithPassword(password);

      if (!mounted) return;

      if (authenticated) {
        _navigateToNotes();
      } else {
        _showError('Incorrect password. Please try again.');
        _passwordController.clear();
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('Authentication failed. Please try again.');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _authenticateWithBiometric() async {
    if (!_biometricEnabled || !_biometricAvailable) {
      print('Biometric auth skipped: enabled=$_biometricEnabled, available=$_biometricAvailable');
      return;
    }

    print('Starting biometric authentication...');
    
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final authenticated = await _authService.authenticateWithBiometric();

      print('Biometric authentication result: $authenticated');

      if (!mounted) return;

      if (authenticated) {
        print('Biometric auth successful! Navigating to notes...');
        _navigateToNotes();
      } else {
        print('Biometric auth failed or cancelled');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error during biometric authentication: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorText = 'Biometric authentication failed. Please use password.';
        });
      }
    }
  }

  void _navigateToNotes() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const NotesListScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: AppDurations.fadeIn,
      ),
    );
  }

  void _showError(String message) {
    setState(() {
      _errorText = message;
    });
    _shakeController.forward(from: 0).then((_) {
      _shakeController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundPrimary,
              AppColors.primaryMain,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lock icon
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryMain.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      size: 80,
                      color: AppColors.secondaryMain,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingLg),
                  
                  // Title
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppDimensions.spacingSm),
                  
                  // Subtitle
                  Text(
                    'Enter your master password',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppDimensions.spacingXl),
                  
                  // Password field
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: CustomTextField(
                      label: AppStrings.masterPassword,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      errorText: _errorText,
                      suffixIcon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onSuffixIconTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onSubmitted: (_) => _authenticateWithPassword(),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingLg),
                  
                  // Unlock button
                  CustomButton(
                    text: 'Unlock',
                    onPressed: _isLoading ? null : _authenticateWithPassword,
                    isLoading: _isLoading,
                    isFullWidth: true,
                    size: CustomButtonSize.large,
                    gradient: AppColors.buttonGradient,
                  ),
                  
                  // Biometric button
                  if (_biometricEnabled && _biometricAvailable) ...[
                    SizedBox(height: AppDimensions.spacingMd),
                    Text(
                      'or',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppDimensions.spacingMd),
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _authenticateWithBiometric,
                      icon: Icon(
                        Icons.fingerprint,
                        color: AppColors.secondaryMain,
                      ),
                      label: Text(
                        'Use $_biometricTypeName',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.secondaryMain,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 56),
                        side: BorderSide(
                          color: AppColors.secondaryMain,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        ),
                      ),
                    ),
                  ],
                  
                  SizedBox(height: AppDimensions.spacingXl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
