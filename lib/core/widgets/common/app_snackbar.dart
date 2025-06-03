import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.successGreen);
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.errorRed);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.warningYellow);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.infoBlue);
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColors.accentWhite),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}