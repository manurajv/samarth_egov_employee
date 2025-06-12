import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import '../constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;

  GlassCard({
    super.key,
    required this.child,
    double? blur,
    this.opacity = 0.2,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) : blur = blur ?? _defaultBlur();


  static double _defaultBlur() {
    // Disable blur on low-performance devices or specific platforms
    if (Platform.isAndroid) {
      // Check Android version or device capabilities if needed
      return 0.0;
    }
    return 5.0; // Default blur for other platforms
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassWhite.withOpacity(opacity),
            border: Border.all(color: AppColors.glassBorder),
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}