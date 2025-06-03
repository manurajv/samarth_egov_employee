import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: AppColors.primaryDarkBlue,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryDarkBlue,
      secondary: AppColors.primaryBlue,
      surface: Colors.white,
      background: AppColors.primaryDarkBlue,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.accentWhite),
      titleTextStyle: TextStyle(
        color: AppColors.accentWhite,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.glassWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder),
      ),
      labelStyle: const TextStyle(color: AppColors.accentWhite),
      hintStyle: TextStyle(color: AppColors.accentWhite.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.accentWhite,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.accentWhite,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.accentWhite,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.accentWhite,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.accentWhite,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.accentWhite,
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.glassWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.zero,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primaryBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.accentWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.errorRed,
      contentTextStyle: TextStyle(color: AppColors.accentWhite),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  );
}
