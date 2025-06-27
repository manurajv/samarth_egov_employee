import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: AppColors.accentWhite, // White as primary for backgrounds
    colorScheme: const ColorScheme.light(
      primary: AppColors.accentWhite, // White for primary elements
      secondary: AppColors.primaryBlue, // Blue for secondary elements
      surface: AppColors.accentWhite, // White for cards, containers
      background: AppColors.accentWhite, // Pure white background
      error: AppColors.errorRed, // Red for errors
      onPrimary: AppColors.primaryDarkBlue, // Dark blue text on white
      onSecondary: AppColors.accentWhite, // White text on blue
      onSurface: AppColors.darkGrey, // Dark grey for text on white surfaces
      onBackground: AppColors.darkGrey, // Dark grey for text on white background
      onError: AppColors.accentWhite, // White text on error red
    ),
    scaffoldBackgroundColor: AppColors.accentWhite, // Pure white scaffold
    appBarTheme: const AppBarTheme(
      elevation: 1, // Subtle shadow for professional look
      centerTitle: true,
      backgroundColor: AppColors.accentWhite, // White app bar
      iconTheme: IconThemeData(color: AppColors.primaryDarkBlue), // Dark blue icons
      titleTextStyle: TextStyle(
        color: AppColors.primaryDarkBlue, // Dark blue title
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightGrey, // Light grey for input fields
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.mediumGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.mediumGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.darkGrey),
      hintStyle: TextStyle(color: AppColors.grey.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDarkBlue, // Dark blue for headers
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDarkBlue,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryDarkBlue,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.darkGrey, // Dark grey for titles
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.darkGrey, // Dark grey for body text
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.darkGrey,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryDarkBlue, // Dark blue for labels
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.lightGrey, // Light grey for cards
      elevation: 2, // Subtle elevation for depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.zero,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primaryBlue, // Blue buttons
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue, // Blue buttons
        foregroundColor: AppColors.accentWhite, // White text/icons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
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