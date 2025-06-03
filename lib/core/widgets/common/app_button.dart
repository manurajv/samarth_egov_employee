import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;
  final double? elevation;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = true,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.elevation,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryBlue,
          foregroundColor: foregroundColor ?? AppColors.accentWhite,
          elevation: elevation ?? 2,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.accentWhite,
          ),
        )
            : Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}