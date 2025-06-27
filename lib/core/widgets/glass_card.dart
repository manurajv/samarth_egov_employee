import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import '../constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;
  final Color? color; // ✅ Add this line

  GlassCard({
    super.key,
    required this.child,
    double? blur,
    this.opacity = 0.2,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.color, // ✅ Add this line
  }) : blur = blur ?? _defaultBlur();

  static double _defaultBlur() {
    if (Platform.isAndroid) {
      return 0.0;
    }
    return 5.0;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: (color ?? AppColors.glassWhite).withOpacity(opacity), // ✅ use passed color
            border: Border.all(color: AppColors.glassBorder),
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
