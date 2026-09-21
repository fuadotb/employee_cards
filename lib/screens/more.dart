import 'package:employee_cards/core/theme/app_colors.dart';
import 'package:employee_cards/widgets/language_dialog.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class MorePage extends StatelessWidget {
  final void Function(Locale locale) onLanguageChanged;

  const MorePage({super.key, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          local.more,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              leading: const Icon(Icons.language, color: AppColors.primary),
              title: Text(
                local.language,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
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
          ],
        ),
      ),
    );
  }
}
