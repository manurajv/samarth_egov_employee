import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/glass_card.dart';
import '../../../../../l10n/app_localizations.dart';

class QuickActions extends StatelessWidget {
  final Function(String) onActionSelected;

  const QuickActions({
    super.key,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quickActions = [
      {
        'icon': FontAwesomeIcons.calendarPlus,
        'label': l10n.applyLeave,
        'action': 'leave',
      },
      {
        'icon': FontAwesomeIcons.fileInvoice,
        'label': l10n.viewSalary,
        'action': 'salary',
      },
      {
        'icon': FontAwesomeIcons.bullhorn,
        'label': l10n.fileGrievance,
        'action': 'grievance',
      },
      {
        'icon': FontAwesomeIcons.userEdit,
        'label': l10n.updateProfile,
        'action': 'profile',
      },
    ];

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quickActions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: quickActions.map((action) {
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onActionSelected(action['action'] as String),
                  child: GlassCard(
                    opacity: 0.1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          FaIcon(
                            action['icon'] as IconData,
                            size: 16,
                            color: AppColors.accentWhite,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            action['label'] as String,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}