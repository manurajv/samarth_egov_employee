import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../glass_card.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? gradientStart;
  final Color? gradientEnd;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.gradientStart,
    this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      blur: 8,
      opacity: 0.2,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradientStart ?? AppColors.primaryBlue.withOpacity(0.7),
              gradientEnd ?? AppColors.secondaryBlue.withOpacity(0.7),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 18,
                        color: AppColors.accentWhite,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentWhite,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}