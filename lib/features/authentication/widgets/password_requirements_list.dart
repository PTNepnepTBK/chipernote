import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';

class PasswordRequirementsList extends StatelessWidget {
  final String password;

  const PasswordRequirementsList({
    Key? key,
    required this.password,
  }) : super(key: key);

  bool _hasMinLength() => password.length >= 8;
  bool _hasUpperLower() =>
      RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password);
  bool _hasNumber() => RegExp(r'[0-9]').hasMatch(password);
  bool _hasSpecialChar() =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirement(
          AppStrings.requirementMinLength,
          _hasMinLength(),
        ),
        SizedBox(height: AppDimensions.spacingSm),
        _buildRequirement(
          AppStrings.requirementUpperLower,
          _hasUpperLower(),
        ),
        SizedBox(height: AppDimensions.spacingSm),
        _buildRequirement(
          AppStrings.requirementNumber,
          _hasNumber(),
        ),
        SizedBox(height: AppDimensions.spacingSm),
        _buildRequirement(
          AppStrings.requirementSpecial,
          _hasSpecialChar(),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return AnimatedSwitcher(
      duration: AppDurations.checkBounce,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
          ),
          child: child,
        );
      },
      child: Row(
        key: ValueKey(isMet),
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: AppDimensions.iconSizeSmall,
            color: isMet ? AppColors.success : AppColors.textDisabled,
          ),
          SizedBox(width: AppDimensions.spacingSm),
          Text(
            text,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
