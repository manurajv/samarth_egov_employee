import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../l10n/app_localizations.dart';

class LeaveSummary extends StatelessWidget {
  const LeaveSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.leaveSummary,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildLeaveSummaryItem(
              context,
              l10n.casualLeave,
              Icons.beach_access,
              '10',
              '2',
              '8',
            ),
            _buildLeaveSummaryItem(
              context,
              l10n.sickLeave,
              Icons.medical_services,
              '15',
              '5',
              '10',
            ),
            _buildLeaveSummaryItem(
              context,
              l10n.earnedLeave,
              Icons.work,
              '30',
              '10',
              '20',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveSummaryItem(
      BuildContext context,
      String leaveType,
      IconData icon,
      String total,
      String used,
      String remaining,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.accentBlue),
              const SizedBox(width: 8),
              Text(
                leaveType,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '$remaining/$total',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.accentBlue,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.glassWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  used,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}