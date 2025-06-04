import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryDarkBlue = Color(0xFF0A2463);
  static const Color primaryBlue = Color(0xFF1E3D8B);
  static const Color secondaryBlue = Color(0xFF3E92CC);
  static const Color accentBlue = Color(0xFF61A5F8);

  // Neutral Colors
  static const Color accentWhite = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF616161);
  static const Color grey = Color(0xFF9E9E9E); // <-- Added gray color

  // Semantic Colors
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color accentGreen = successGreen; // Alias for successGreen
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color errorRed = Color(0xFFE57373);
  static const Color accentRed = errorRed; // Alias for errorRed
  static const Color infoBlue = Color(0xFF2196F3);

  // Accent Colors
  static const Color accentYellow = Color(0xFFFFF176);  // Light yellow accent

  // Glassmorphism Colors
  static const Color glassWhite = Color(0x20FFFFFF);
  static const Color glassBorder = Color(0x30FFFFFF);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF1E3D8B); // Matches primaryBlue
  static const Color gradientEnd = Color(0xFF3E92CC);   // Matches secondaryBlue
}
