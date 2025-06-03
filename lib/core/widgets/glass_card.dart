import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 5.0,
    this.opacity = 0.2,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

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