import 'package:employee_cards/core/theme/app_colors.dart';
import 'package:employee_cards/l10n/app_localizations.dart';
import 'package:employee_cards/widgets/nav_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavBar({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;
     final local = AppLocalizations.of(context)!;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            NavItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label:local.home,
              selected: currentIndex == 0,
              onTap: () => _onTap(context, 0),
            ),

            NavItem(
              icon: Icons.badge_outlined,
              selectedIcon: Icons.badge_rounded,
              label: local.services,
              selected: currentIndex == 1,
              onTap: () => _onTap(context, 1),
            ),

            NavItem(
              icon: Icons.more_horiz_outlined,
              selectedIcon: Icons.more_horiz_rounded,
              label: local.more,
              selected: currentIndex == 2,
              onTap: () => _onTap(context, 2),
            ),
          ],
        ),
      ),
    );
  }
}
