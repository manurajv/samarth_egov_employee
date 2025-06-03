import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/utils/helpers/local_storage_helper.dart';
import '../../core/utils/helpers/localization_helper.dart';
import '../../l10n/app_localizations.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return PopupMenuButton<Locale>(
      icon: FaIcon(
        FontAwesomeIcons.language,
        color: theme.colorScheme.onBackground,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              const FaIcon(FontAwesomeIcons.language, size: 16),
              const SizedBox(width: 8),
              Text(l10n.english),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('hi'),
          child: Row(
            children: [
              const FaIcon(FontAwesomeIcons.language, size: 16),
              const SizedBox(width: 8),
              Text(l10n.hindi),
            ],
          ),
        ),
      ],
      onSelected: (Locale value) async {
        await LocalStorageHelper.setLanguage(value.languageCode);
        Provider.of<LocaleProvider>(context, listen: false).setLocale(value);
      },
    );
  }
}