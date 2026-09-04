import 'package:equatable/equatable.dart';

import '../domain/task.dart';
import '../domain/task_priority.dart';
import 'task_state.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

/// Chargement initial des tâches.
class LoadTasks extends TaskEvent {}

/// Ajout d'une nouvelle tâche.
class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Mise à jour d'une tâche existante.
class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Suppression d'une tâche.
class DeleteTask extends TaskEvent {
  final String id;

  const DeleteTask(this.id);

  @override
  List<Object?> get props => [id];
}

/// Bascule l'état complété/non complété.
class ToggleTask extends TaskEvent {
  final Task task;

  const ToggleTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Met à jour la recherche textuelle.
class SetSearchQuery extends TaskEvent {
  final String query;

  const SetSearchQuery(this.query);

  @override
  List<Object?> get props => [query];
}

/// Applique un filtre de statut.
class SetStatusFilter extends TaskEvent {
  final TaskStatusFilter filter;

  const SetStatusFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Applique un filtre de priorité (null = tous).
class SetPriorityFilter extends TaskEvent {
  final TaskPriority? priority;

  const SetPriorityFilter(this.priority);

  @override
  List<Object?> get props => [priority];
}

/// Change le critère et le sens de tri.
class SetSort extends TaskEvent {
  final TaskSortBy sortBy;
  final bool ascending;

  const SetSort(this.sortBy, {this.ascending = true});

  @override
  List<Object?> get props => [sortBy, ascending];
}
