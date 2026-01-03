import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_durations.dart';

enum CustomButtonVariant {
  primary,
  secondary,
  text,
  outlined,
  danger,
}

enum CustomButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final CustomButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Gradient? gradient;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.gradient,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.buttonPress,
      reverseDuration: AppDurations.buttonRelease,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppDimensions.scaleMin,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  Color _getBackgroundColor() {
    switch (widget.variant) {
      case CustomButtonVariant.primary:
        return AppColors.secondaryMain;
      case CustomButtonVariant.secondary:
        return AppColors.surface;
      case CustomButtonVariant.text:
        return Colors.transparent;
      case CustomButtonVariant.outlined:
        return Colors.transparent;
      case CustomButtonVariant.danger:
        return AppColors.danger;
    }
  }

  Color _getTextColor() {
    switch (widget.variant) {
      case CustomButtonVariant.primary:
      case CustomButtonVariant.danger:
        return AppColors.textPrimary;
      case CustomButtonVariant.secondary:
        return AppColors.textSecondary;
      case CustomButtonVariant.text:
      case CustomButtonVariant.outlined:
        return AppColors.secondaryMain;
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case CustomButtonSize.small:
        return AppDimensions.buttonHeightSmall;
      case CustomButtonSize.medium:
        return AppDimensions.buttonHeightMedium;
      case CustomButtonSize.large:
        return AppDimensions.buttonHeightLarge;
    }
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case CustomButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd,
          vertical: AppDimensions.spacingSm,
        );
      case CustomButtonSize.medium:
      case CustomButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingMd,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabled ? null : _handleTapDown,
      onTapUp: isDisabled ? null : _handleTapUp,
      onTapCancel: isDisabled ? null : _handleTapCancel,
      onTap: isDisabled ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: _getHeight(),
          width: widget.isFullWidth ? double.infinity : null,
          decoration: BoxDecoration(
            gradient: widget.variant == CustomButtonVariant.primary &&
                    widget.gradient != null
                ? widget.gradient
                : null,
            color: widget.gradient == null ? _getBackgroundColor() : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: widget.variant == CustomButtonVariant.outlined
                ? Border.all(color: AppColors.divider, width: 1)
                : null,
            boxShadow: widget.variant == CustomButtonVariant.primary
                ? [
                    BoxShadow(
                      color: AppColors.shadow2,
                      blurRadius: AppDimensions.shadowBlur2,
                      offset: Offset(0, AppDimensions.shadowOffsetY2),
                    ),
                  ]
                : null,
          ),
          padding: _getPadding(),
          child: widget.isLoading
              ? Center(
                  child: SizedBox(
                    width: AppDimensions.iconSizeMedium,
                    height: AppDimensions.iconSizeMedium,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: widget.isFullWidth
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.leadingIcon != null) ...[
                      widget.leadingIcon!,
                      SizedBox(width: AppDimensions.spacingSm),
                    ],
                    Text(
                      widget.text,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: _getTextColor(),
                      ),
                    ),
                    if (widget.trailingIcon != null) ...[
                      SizedBox(width: AppDimensions.spacingSm),
                      widget.trailingIcon!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
