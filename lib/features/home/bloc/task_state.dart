import 'package:equatable/equatable.dart';

import '../domain/task.dart';
import '../domain/task_priority.dart';

/// Filtre sur l'état d'avancement.
enum TaskStatusFilter { all, pending, completed, overdue, today }

/// Critère de tri.
enum TaskSortBy { date, priority, title, createdAt }

/// État du bloc des tâches.
class TaskState extends Equatable {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final TaskStatusFilter statusFilter;
  final TaskPriority? priorityFilter;
  final TaskSortBy sortBy;
  final bool ascending;

  const TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.statusFilter = TaskStatusFilter.all,
    this.priorityFilter,
    this.sortBy = TaskSortBy.date,
    this.ascending = true,
  });

  /// Tâches après application de la recherche, des filtres et du tri.
  List<Task> get filteredTasks {
    var list = List<Task>.of(tasks);

    // Recherche textuelle.
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where(
            (t) =>
                t.title.toLowerCase().contains(q) ||
                t.description.toLowerCase().contains(q),
          )
          .toList();
    }

    // Filtre par priorité.
    if (priorityFilter != null) {
      list = list.where((t) => t.priority == priorityFilter).toList();
    }

    // Filtre par statut.
    final now = DateTime.now();
    list = list.where((t) {
      switch (statusFilter) {
        case TaskStatusFilter.all:
          return true;
        case TaskStatusFilter.pending:
          return !t.isCompleted;
        case TaskStatusFilter.completed:
          return t.isCompleted;
        case TaskStatusFilter.overdue:
          return t.isOverdue;
        case TaskStatusFilter.today:
          return t.date.year == now.year &&
              t.date.month == now.month &&
              t.date.day == now.day;
      }
    }).toList();

    // Tri.
    list.sort((a, b) {
      int cmp;
      switch (sortBy) {
        case TaskSortBy.date:
          cmp = a.date.compareTo(b.date);
        case TaskSortBy.priority:
          cmp = b.priority.rank.compareTo(a.priority.rank);
        case TaskSortBy.title:
          cmp = a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case TaskSortBy.createdAt:
          cmp = (a.createdAt ?? a.date).compareTo(b.createdAt ?? b.date);
      }
      return ascending ? cmp : -cmp;
    });

    return list;
  }

  List<Task> get todayTasks {
    final now = DateTime.now();
    return tasks
        .where(
          (t) =>
              t.date.year == now.year &&
              t.date.month == now.month &&
              t.date.day == now.day,
        )
        .toList();
  }

  List<Task> get overdueTasks => tasks.where((t) => t.isOverdue).toList();

  int get completedCount => tasks.where((t) => t.isCompleted).length;

  double get progress {
    if (tasks.isEmpty) return 0;
    return completedCount / tasks.length;
  }

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? error,
    String? searchQuery,
    TaskStatusFilter? statusFilter,
    TaskPriority? priorityFilter,
    TaskSortBy? sortBy,
    bool? ascending,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  @override
  List<Object?> get props => [
    tasks,
    isLoading,
    error,
    searchQuery,
    statusFilter,
    priorityFilter,
    sortBy,
    ascending,
  ];
}
