import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LanguageDialog extends StatelessWidget {
  final void Function(Locale locale) onLanguageChanged;

  const LanguageDialog({ 
    super.key,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(local.language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(local.arabic),
            onTap: () {
              onLanguageChanged(const Locale('ar'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(local.english),
            onTap: () {
              onLanguageChanged(const Locale('en'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

