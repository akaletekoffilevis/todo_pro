import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';

/// Barre de navigation inférieure premium.
class AppNavBar extends StatelessWidget {
  final int currentIndex;

  const AppNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return NavigationBar(
      selectedIndex: currentIndex,
      height: 68,
      backgroundColor: Theme.of(context).cardTheme.color,
      elevation: 0,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/');
          case 1:
            context.go('/tasks');
          case 2:
            context.go('/stats');
          case 3:
            context.go('/settings');
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.today_outlined),
          selectedIcon: const Icon(Icons.today),
          label: l10n.navHome,
        ),
        NavigationDestination(
          icon: const Icon(Icons.checklist_outlined),
          selectedIcon: const Icon(Icons.checklist),
          label: l10n.navTasks,
        ),
        NavigationDestination(
          icon: const Icon(Icons.bar_chart_outlined),
          selectedIcon: const Icon(Icons.bar_chart),
          label: l10n.navStats,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: l10n.navSettings,
        ),
      ],
    );
  }
}
