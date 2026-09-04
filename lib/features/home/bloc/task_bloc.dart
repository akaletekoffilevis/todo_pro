import 'package:bloc/bloc.dart';

import '../domain/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

/// Bloc gérant la logique métier des tâches, filtres et tri.
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(const TaskState()) {
    on<LoadTasks>(_onLoad);
    on<AddTask>(_onAdd);
    on<UpdateTask>(_onUpdate);
    on<DeleteTask>(_onDelete);
    on<ToggleTask>(_onToggle);
    on<SetSearchQuery>(_onSetSearch);
    on<SetStatusFilter>(_onSetStatus);
    on<SetPriorityFilter>(_onSetPriority);
    on<SetSort>(_onSetSort);
  }

  Future<void> _onLoad(LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final tasks = await repository.getTasks();
      emit(state.copyWith(tasks: tasks, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load tasks'));
    }
  }

  Future<void> _onAdd(AddTask event, Emitter<TaskState> emit) async {
    await repository.addTask(event.task);
    final tasks = await repository.getTasks();
    emit(state.copyWith(tasks: tasks));
  }

  Future<void> _onUpdate(UpdateTask event, Emitter<TaskState> emit) async {
    await repository.updateTask(event.task);
    final tasks = await repository.getTasks();
    emit(state.copyWith(tasks: tasks));
  }

  Future<void> _onDelete(DeleteTask event, Emitter<TaskState> emit) async {
    await repository.deleteTask(event.id);
    final tasks = await repository.getTasks();
    emit(state.copyWith(tasks: tasks));
  }

  Future<void> _onToggle(ToggleTask event, Emitter<TaskState> emit) async {
    final updated = event.task.copyWith(isCompleted: !event.task.isCompleted);
    await repository.updateTask(updated);
    final tasks = await repository.getTasks();
    emit(state.copyWith(tasks: tasks));
  }

  void _onSetSearch(SetSearchQuery event, Emitter<TaskState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSetStatus(SetStatusFilter event, Emitter<TaskState> emit) {
    emit(state.copyWith(statusFilter: event.filter));
  }

  void _onSetPriority(SetPriorityFilter event, Emitter<TaskState> emit) {
    emit(state.copyWith(priorityFilter: event.priority));
  }

  void _onSetSort(SetSort event, Emitter<TaskState> emit) {
    emit(state.copyWith(sortBy: event.sortBy, ascending: event.ascending));
  }
}
