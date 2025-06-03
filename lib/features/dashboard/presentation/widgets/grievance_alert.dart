import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../l10n/app_localizations.dart';

class GrievanceAlert extends StatelessWidget {
  final bool hasPendingGrievance;

  const GrievanceAlert({
    super.key,
    this.hasPendingGrievance = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!hasPendingGrievance) return const SizedBox.shrink();

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.exclamationTriangle,
              color: AppColors.warningYellow,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.pendingGrievanceAlert,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                // Navigate to grievances screen
                Navigator.pushNamed(context, '/grievances');
              },
              child: Text(
                l10n.viewDetails,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.accentBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}