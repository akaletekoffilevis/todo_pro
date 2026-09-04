import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/cloud_scope.dart';
import '../../../../core/widgets/app_nav_bar.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../../core/widgets/support_clipboard.dart';
import '../../../../features/auth/data/auth_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../bloc/settings_cubit.dart';
import '../../bloc/settings_state.dart';

/// Écran de paramètres : thème, langue, notifications (design premium).
class SettingsScreen extends HookWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: ResponsiveWrapper(
        child: SafeArea(
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settings) {
              final cubit = context.read<SettingsCubit>();
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                children: [
                  Text(
                    l10n.settingsTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (CloudScope.maybeOf(context) != null) ...[
                    // Section Compte (cloud Firebase).
                    Text(
                      l10n.settingsAccount.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF6C5CE7),
                                foregroundImage: CloudScope.currentUser(context)
                                            ?.photoUrl !=
                                        null
                                    ? NetworkImage(
                                        CloudScope.currentUser(context)!.photoUrl!,
                                      )
                                    : null,
                                child: Text(
                                  (CloudScope.currentUser(context)?.email ??
                                          l10n.anonymousUser)
                                      .substring(0, 1)
                                      .toUpperCase(),
                                ),
                              ),
                              title: Text(
                                CloudScope.currentUser(context)?.email ??
                                    l10n.anonymousUser,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                CloudScope.getCloudEnabled(context)
                                    ? l10n.cloudSyncEnabled
                                    : l10n.cloudSyncOffline,
                              ),
                              trailing: IconButton(
                                tooltip: l10n.signOut,
                                onPressed: () async {
                                  final auth = AuthService();
                                  try {
                                    await auth.signOut();
                                  } catch (_) {}
                                },
                                icon: const Icon(Icons.logout),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Section Apparence.
                  Text(
                    l10n.settingsAppearance.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Thème clair / sombre.
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.dark_mode_outlined,
                            color: Color(0xFF6C5CE7),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.darkMode,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Switch(
                            value: settings.themeMode == ThemeMode.dark,
                            onChanged: (_) => cubit.toggleTheme(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Langue.
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.language, color: Color(0xFF2979FF)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.language,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'fr', label: Text('FR')),
                              ButtonSegment(value: 'en', label: Text('EN')),
                            ],
                            selected: {settings.locale.languageCode},
                            onSelectionChanged: (values) {
                              cubit.setLocale(Locale(values.first));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Notifications.
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFFFF3D71),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.notifications,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Switch(
                            value: settings.notifications,
                            onChanged: (_) => cubit.toggleNotifications(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Section Aide & support.
                  Text(
                    l10n.settingsSupport.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.support_agent,
                                color: Color(0xFF00BFA6),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.supportTitle,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.supportDescription,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF2979FF),
                            ),
                            title: Text(
                              l10n.supportEmailLabel,
                              style: theme.textTheme.bodySmall,
                            ),
                            subtitle: SelectableText(
                              l10n.supportEmail,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () async {
                                final copied = await const SupportClipboard()
                                    .copy(l10n.supportEmail);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      copied
                                          ? l10n.supportEmailCopied
                                          : l10n.supportContactUs,
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy),
                              label: Text(l10n.supportContactUs),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 3),
    );
  }
}
