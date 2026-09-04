import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_nav_bar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../bloc/task_state.dart';
import '../../domain/task_priority.dart';
import '../widgets/task_card.dart';

/// Écran listant toutes les tâches avec recherche, filtres et tri.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.allTasksTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.filters,
                    onPressed: () => _openSortSheet(context, l10n),
                    icon: const Icon(Icons.tune),
                  ),
                ],
              ),
            ),
            // Recherche + filtres de statut.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (value) =>
                    context.read<TaskBloc>().add(SetSearchQuery(value)),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l10n.searchPlaceholder,
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<TaskBloc>().add(SetSearchQuery(''));
                          },
                        ),
                ),
              ),
            ),
            // Chips de filtre de statut.
            BlocBuilder<TaskBloc, TaskState>(
              buildWhen: (prev, curr) => prev.statusFilter != curr.statusFilter,
              builder: (context, state) {
                return SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: TaskStatusFilter.values.map((filter) {
                      final selected = state.statusFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(_statusLabel(l10n, filter)),
                          selected: selected,
                          onSelected: (_) => context.read<TaskBloc>().add(
                            SetStatusFilter(filter),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            // Liste des tâches.
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  final tasks = state.filteredTasks;
                  if (tasks.isEmpty) {
                    return _EmptyList(l10n: l10n);
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    itemCount: tasks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Dismissible(
                        key: Key(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          context.read<TaskBloc>().add(DeleteTask(task.id));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(task.title),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: TaskCard(
                          task: task,
                          checkboxKey: Key('toggle_${task.id}'),
                          onTap: () => context.push('/editor', extra: task),
                          onToggle: () =>
                              context.read<TaskBloc>().add(ToggleTask(task)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('tasks_add_fab'),
        tooltip: l10n.addTask,
        onPressed: () => context.push('/editor'),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const AppNavBar(currentIndex: 1),
    );
  }

  String _statusLabel(AppLocalizations l10n, TaskStatusFilter filter) {
    switch (filter) {
      case TaskStatusFilter.all:
        return l10n.statusAll;
      case TaskStatusFilter.pending:
        return l10n.statusPending;
      case TaskStatusFilter.completed:
        return l10n.statusCompleted;
      case TaskStatusFilter.overdue:
        return l10n.statusOverdue;
      case TaskStatusFilter.today:
        return l10n.statusToday;
    }
  }

  void _openSortSheet(BuildContext context, AppLocalizations l10n) {
    final bloc = context.read<TaskBloc>();
    final state = bloc.state;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sortBy,
                      style: Theme.of(sheetContext).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TaskSortBy.values.map((sort) {
                        final label = _sortLabel(l10n, sort);
                        final selected = state.sortBy == sort;
                        return ChoiceChip(
                          label: Text(label),
                          selected: selected,
                          onSelected: (_) {
                            bloc.add(SetSort(sort));
                            setSheetState(() {});
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(value: true, label: Text(l10n.ascending)),
                        ButtonSegment(
                          value: false,
                          label: Text(l10n.descending),
                        ),
                      ],
                      selected: {state.ascending},
                      onSelectionChanged: (values) {
                        bloc.add(
                          SetSort(state.sortBy, ascending: values.first),
                        );
                        setSheetState(() {});
                      },
                    ),
                    const Divider(height: 32),
                    Text(
                      l10n.taskPriority,
                      style: Theme.of(sheetContext).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text(l10n.priorityAll),
                          selected: state.priorityFilter == null,
                          onSelected: (_) {
                            bloc.add(SetPriorityFilter(null));
                            setSheetState(() {});
                          },
                        ),
                        ...TaskPriority.values.map((p) {
                          final selected = state.priorityFilter == p;
                          return ChoiceChip(
                            label: Text(_priorityLabel(l10n, p)),
                            selected: selected,
                            onSelected: (_) {
                              bloc.add(SetPriorityFilter(p));
                              setSheetState(() {});
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _sortLabel(AppLocalizations l10n, TaskSortBy sort) {
    switch (sort) {
      case TaskSortBy.date:
        return l10n.sortDate;
      case TaskSortBy.priority:
        return l10n.sortPriority;
      case TaskSortBy.title:
        return l10n.sortTitle;
      case TaskSortBy.createdAt:
        return l10n.sortCreated;
    }
  }

  String _priorityLabel(AppLocalizations l10n, TaskPriority p) {
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

class _EmptyList extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyList({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 56),
          const SizedBox(height: 12),
          Text(l10n.noResults, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l10n.noResultsHint),
        ],
      ),
    );
  }
}
