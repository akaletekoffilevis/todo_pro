import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_nav_bar.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../bloc/task_state.dart';
import '../widgets/live_clock.dart';
import '../widgets/task_card.dart';

/// Écran d'accueil "Aujourd'hui" : horloge live + tâches du jour + stats.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: ResponsiveWrapper(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => context.read<TaskBloc>().add(LoadTasks()),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.appTitle,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            _FocusButton(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.appTagline,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
const SizedBox(height: 18),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: const LiveClock(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Section stats rapides.
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        return _QuickStats(
                          total: state.tasks.length,
                          done: state.completedCount,
                          overdue: state.overdueTasks.length,
                          progress: state.progress,
                        );
                      },
                    ),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(child: SizedBox()),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      l10n.todayTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  sliver: SliverToBoxAdapter(child: SizedBox()),
                ),
                // Tâches du jour.
                BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    final today = state.todayTasks;
                    if (today.isEmpty) {
                      return const SliverPadding(
                        padding: EdgeInsets.all(24),
                        sliver: SliverToBoxAdapter(child: _EmptyHome()),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList.separated(
                        itemCount: today.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = today[index];
                          return TaskCard(
                            task: task,
                            onTap: () => context.push('/editor', extra: task),
                            onToggle: () =>
                                context.read<TaskBloc>().add(ToggleTask(task)),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SliverPadding(
                  padding: EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(child: SizedBox()),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('home_add_button'),
        tooltip: l10n.addTask,
        onPressed: () => context.push('/editor'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addTask),
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 0),
    );
  }
}

class _FocusButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      tooltip: l10n.focusTitle,
      onPressed: () => context.push('/focus'),
      icon: const Icon(Icons.timer_outlined),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  final int total;
  final int done;
  final int overdue;
  final double progress;

  const _QuickStats({
    required this.total,
    required this.done,
    required this.overdue,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatValue(label: l10n.statsTotal, value: total),
              _StatValue(label: l10n.statsDone, value: done),
              _StatValue(
                label: l10n.statsOverdue,
                value: overdue,
                color: overdue > 0 ? Colors.red : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatValue extends StatelessWidget {
  final String label;
  final int value;
  final Color? color;

  const _StatValue({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          '$value',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: color ?? theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(
          Icons.wb_sunny_outlined,
          size: 56,
          color: theme.colorScheme.primary.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.noTasks,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.noTasksHint,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
