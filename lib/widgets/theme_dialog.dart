import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class ThemeDialog extends StatelessWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode themeMode) onThemeChanged;

  const ThemeDialog({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(local.appearance),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.light_mode_outlined),
            title: Text(local.light),

            trailing: themeMode == ThemeMode.light
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              onThemeChanged(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(local.dark),
            trailing: themeMode == ThemeMode.dark
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              onThemeChanged(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
