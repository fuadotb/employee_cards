import 'package:employee_cards/widgets/language_dialog.dart';
import 'package:employee_cards/widgets/theme_dialog.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class MorePage extends StatelessWidget {
  final void Function(Locale locale) onLanguageChanged;
  final ThemeMode themeMode;
  final void Function(ThemeMode themeMode) onThemeChanged;

  const MorePage({
    super.key,
    required this.onLanguageChanged,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              local.more,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Language
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              tileColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                ),
              ),
              leading: Icon(Icons.language, color: colorScheme.primary),
              title: Text(
                local.language,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return LanguageDialog(onLanguageChanged: onLanguageChanged);
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            // Appearance
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              tileColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                ),
              ),
              leading: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                color: colorScheme.primary,
              ),
              title: Text(
                local.appearance,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ThemeDialog(
                      themeMode: themeMode,
                      onThemeChanged: onThemeChanged,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
