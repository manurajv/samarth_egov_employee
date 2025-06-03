import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isImportant;
  final IconData? icon;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isImportant = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: AppColors.accentWhite.withOpacity(0.7),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.accentWhite.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight:
                isImportant ? FontWeight.bold : FontWeight.normal,
                color: AppColors.accentWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}