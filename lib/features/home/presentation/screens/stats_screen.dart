import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_nav_bar.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../bloc/task_bloc.dart';
import '../../domain/task.dart';
import '../../domain/task_category.dart';
import '../../domain/task_priority.dart';

/// Écran de statistiques avancées (répartition par catégorie / priorité).
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = context.watch<TaskBloc>().state;

    return Scaffold(
      body: ResponsiveWrapper(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            children: [
              Text(
                l10n.statsTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              // Carte de progression globale.
              _ProgressCard(
                progress: state.progress,
                total: state.tasks.length,
                done: state.completedCount,
                overdue: state.overdueTasks.length,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.statsByCategory,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _CategoryBreakdown(tasks: state.tasks),
              const SizedBox(height: 24),
              Text(
                l10n.statsByPriority,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _PriorityBreakdown(tasks: state.tasks),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 2),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final double progress;
  final int total;
  final int done;
  final int overdue;

  const _ProgressCard({
    required this.progress,
    required this.total,
    required this.done,
    required this.overdue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C5CE7), Color(0xFF8E7BFF)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.progressLabel,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WhiteStat(label: l10n.statsTotal, value: '$total'),
              _WhiteStat(label: l10n.statsDone, value: '$done'),
              _WhiteStat(label: l10n.statsOverdue, value: '$overdue'),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhiteStat extends StatelessWidget {
  final String label;
  final String value;

  const _WhiteStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// Barres horizontales par catégorie avec compteur et progression.
class _CategoryBreakdown extends StatelessWidget {
  final List<Task> tasks;

  const _CategoryBreakdown({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }
    final total = tasks.length;
    final byCat = <TaskCategory, int>{};
    for (final t in tasks) {
      byCat[t.category] = (byCat[t.category] ?? 0) + 1;
    }
    return Column(
      children: TaskCategory.values.map((c) {
        final count = byCat[c] ?? 0;
        final fraction = count / total;
        return _CountBar(
          color: c.color,
          icon: c.icon,
          label: _catLabel(context, c),
          count: count,
          fraction: fraction,
        );
      }).toList(),
    );
  }

  static String _catLabel(BuildContext context, TaskCategory c) {
    final l10n = AppLocalizations.of(context)!;
    switch (c) {
      case TaskCategory.personal:
        return l10n.categoryPersonal;
      case TaskCategory.work:
        return l10n.categoryWork;
      case TaskCategory.health:
        return l10n.categoryHealth;
      case TaskCategory.shopping:
        return l10n.categoryShopping;
      case TaskCategory.studies:
        return l10n.categoryStudies;
      case TaskCategory.other:
        return l10n.categoryOther;
    }
  }
}

class _PriorityBreakdown extends StatelessWidget {
  final List<Task> tasks;

  const _PriorityBreakdown({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }
    final total = tasks.length;
    final byP = <TaskPriority, int>{};
    for (final t in tasks) {
      byP[t.priority] = (byP[t.priority] ?? 0) + 1;
    }
    return Column(
      children: TaskPriority.values.map((p) {
        final count = byP[p] ?? 0;
        return _CountBar(
          color: p.color,
          icon: p.icon,
          label: _prioLabel(context, p),
          count: count,
          fraction: count / total,
        );
      }).toList(),
    );
  }

  static String _prioLabel(BuildContext context, TaskPriority p) {
    final l10n = AppLocalizations.of(context)!;
    switch (p) {
      case TaskPriority.low:
        return l10n.priorityLow;
      case TaskPriority.medium:
        return l10n.priorityMedium;
      case TaskPriority.high:
        return l10n.priorityHigh;
      case TaskPriority.urgent:
        return l10n.priorityUrgent;
    }
  }
}

class _CountBar extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final int count;
  final double fraction;

  const _CountBar({
    required this.color,
    required this.icon,
    required this.label,
    required this.count,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 24,
            child: Text(
              '$count',
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
