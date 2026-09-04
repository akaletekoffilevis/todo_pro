import 'package:todo_pro/features/home/domain/task.dart';
import 'package:todo_pro/features/home/domain/task_category.dart';
import 'package:todo_pro/features/home/domain/task_priority.dart';
import 'package:todo_pro/features/home/domain/task_repository.dart';

/// Repository en mémoire partagé par les tests.
class FakeTaskRepository implements TaskRepository {
  final List<Task> _tasks;

  FakeTaskRepository([List<Task>? initial]) : _tasks = List.of(initial ?? []);

  @override
  Future<List<Task>> getTasks() async => List.of(_tasks);

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i >= 0) _tasks[i] = task;
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
  }
}

Task buildTask({
  String id = '1',
  String title = 'Task',
  String description = '',
  DateTime? date,
  bool isCompleted = false,
  TaskCategory category = TaskCategory.other,
  TaskPriority priority = TaskPriority.medium,
}) {
  return Task(
    id: id,
    title: title,
    description: description,
    date: date ?? DateTime(2026, 1, 1),
    createdAt: DateTime(2026, 1, 1),
    isCompleted: isCompleted,
    category: category,
    priority: priority,
  );
}
