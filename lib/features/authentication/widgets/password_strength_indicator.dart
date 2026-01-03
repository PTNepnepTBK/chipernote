import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';

enum PasswordStrength {
  weak,
  medium,
  strong,
}

class PasswordStrengthIndicator extends StatefulWidget {
  final String password;
  final ValueChanged<PasswordStrength>? onStrengthChanged;

  const PasswordStrengthIndicator({
    Key? key,
    required this.password,
    this.onStrengthChanged,
  }) : super(key: key);

  @override
  State<PasswordStrengthIndicator> createState() =>
      _PasswordStrengthIndicatorState();
}

class _PasswordStrengthIndicatorState extends State<PasswordStrengthIndicator> {
  PasswordStrength _currentStrength = PasswordStrength.weak;

  @override
  void didUpdateWidget(PasswordStrengthIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.password != widget.password) {
      _calculateStrength();
    }
  }

  void _calculateStrength() {
    final password = widget.password;
    int score = 0;

    if (password.length >= 8) {
      score++;
    }
    if (password.length >= 12) {
      score++;
    }
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'[0-9]').hasMatch(password)) {
      score++;
    }
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      score++;
    }

    PasswordStrength newStrength;
    if (score <= 2) {
      newStrength = PasswordStrength.weak;
    } else if (score <= 4) {
      newStrength = PasswordStrength.medium;
    } else {
      newStrength = PasswordStrength.strong;
    }

    if (newStrength != _currentStrength) {
      setState(() {
        _currentStrength = newStrength;
      });
      widget.onStrengthChanged?.call(newStrength);
    }
  }

  Color _getStrengthColor() {
    switch (_currentStrength) {
      case PasswordStrength.weak:
        return AppColors.danger;
      case PasswordStrength.medium:
        return AppColors.warning;
      case PasswordStrength.strong:
        return AppColors.success;
    }
  }

  String _getStrengthText() {
    switch (_currentStrength) {
      case PasswordStrength.weak:
        return AppStrings.weak;
      case PasswordStrength.medium:
        return AppStrings.medium;
      case PasswordStrength.strong:
        return AppStrings.strong;
    }
  }

  double _getStrengthProgress() {
    switch (_currentStrength) {
      case PasswordStrength.weak:
        return 0.3;
      case PasswordStrength.medium:
        return 0.6;
      case PasswordStrength.strong:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          child: SizedBox(
            height: AppDimensions.passwordStrengthBarHeight,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: AppColors.divider,
                ),
                AnimatedContainer(
                  duration: AppDurations.passwordStrengthFill,
                  curve: Curves.easeOut,
                  width: MediaQuery.of(context).size.width *
                      _getStrengthProgress(),
                  color: _getStrengthColor(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppDimensions.spacingSm),
        // Strength label
        AnimatedSwitcher(
          duration: AppDurations.normal,
          child: Text(
            '${AppStrings.passwordStrength}: ${_getStrengthText()}',
            key: ValueKey(_currentStrength),
            style: AppTextStyles.labelSmall.copyWith(
              color: _getStrengthColor(),
            ),
          ),
        ),
      ],
    );
  }
}
