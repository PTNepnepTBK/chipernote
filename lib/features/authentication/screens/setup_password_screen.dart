import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/biometric_auth_service.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/password_requirements_list.dart';
import '../../notes/screens/notes_list_screen.dart';

class SetupPasswordScreen extends StatefulWidget {
  const SetupPasswordScreen({Key? key}) : super(key: key);

  @override
  State<SetupPasswordScreen> createState() => _SetupPasswordScreenState();
}

class _SetupPasswordScreenState extends State<SetupPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _enableBiometric = false;
  bool _isLoading = false;
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
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final biometricService = BiometricAuthService();
    final isAvailable = await biometricService.isBiometricAvailable();
    final typeName = await biometricService.getBiometricTypeName();
    
    print('=== Setup: Checking Biometric ===');
    print('Available: $isAvailable');
    print('Type: $typeName');
    
    if (mounted) {
      setState(() {
        _biometricAvailable = isAvailable;
        _biometricTypeName = typeName;
        // Auto-enable biometric if available
        if (isAvailable) {
          _enableBiometric = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _handleCreatePassword() async {
    setState(() {
      _errorText = null;
    });

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty) {
      _showError('Please enter a password');
      return;
    }

    if (password.length < 8) {
      _showError('Password must be at least 8 characters');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Setup master password using AuthService
      final authService = AuthService();
      
      print('=== Creating Master Password ===');
      print('Biometric enabled: ${_enableBiometric && _biometricAvailable}');
      
      final success = await authService.setupMasterPassword(
        password: password,
        enableBiometric: _enableBiometric && _biometricAvailable,
      );

      print('Setup result: $success');

      if (!success) {
        _showError('Failed to create password. Please try again.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Authenticate with the newly created password
      print('Authenticating with new password...');
      final authenticated = await authService.authenticateWithPassword(password);
      print('Authentication result: $authenticated');

      if (!mounted) return;

      if (authenticated) {
        print('Success! Navigating to notes...');
        // Navigate to notes screen
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
      } else {
        _showError('Authentication failed. Please try again.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showError('An error occurred. Please try again.');
      setState(() {
        _isLoading = false;
      });
    }
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: AppColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppDimensions.spacingLg),
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
                  AppStrings.createMasterPassword,
                  style: AppTextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spacingMd),
                // Subtitle
                Text(
                  AppStrings.masterPasswordSubtitle,
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
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(height: AppDimensions.spacingMd),
                // Password strength indicator
                PasswordStrengthIndicator(
                  password: _passwordController.text,
                ),
                SizedBox(height: AppDimensions.spacingMd),
                // Confirm password field
                CustomTextField(
                  label: AppStrings.confirmPassword,
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  errorText: _errorText,
                  suffixIcon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onSuffixIconTap: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                SizedBox(height: AppDimensions.spacingLg),
                // Password requirements
                PasswordRequirementsList(
                  password: _passwordController.text,
                ),
                // Biometric toggle - only show if available
                if (_biometricAvailable) ...[
                  SizedBox(height: AppDimensions.spacingLg),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMd,
                      vertical: AppDimensions.spacingMd,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.5),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.fingerprint,
                          color: AppColors.secondaryMain,
                          size: AppDimensions.iconSizeMedium,
                        ),
                        SizedBox(width: AppDimensions.spacingMd),
                        Expanded(
                          child: Text(
                            'Enable $_biometricTypeName',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Switch(
                          value: _enableBiometric,
                          onChanged: (value) {
                            setState(() {
                              _enableBiometric = value;
                            });
                          },
                          activeColor: AppColors.secondaryMain,
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: AppDimensions.spacingXl),
                // Create button
                CustomButton(
                  text: AppStrings.createAndSecure,
                  onPressed: _isLoading ? null : _handleCreatePassword,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  size: CustomButtonSize.large,
                  gradient: AppColors.buttonGradient,
                ),
                SizedBox(height: AppDimensions.spacingXl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
