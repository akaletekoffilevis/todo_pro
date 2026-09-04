import 'package:hive/hive.dart';

import '../../domain/task.dart';
import '../../domain/task_category.dart';
import '../../domain/task_priority.dart';

/// Datasource locale basée sur Hive avec sérialisation manuelle.
class HiveTaskLocalDatasource {
  late final Box _box;

  static const _keyId = 'id';
  static const _keyTitle = 'title';
  static const _keyDescription = 'description';
  static const _keyDate = 'date';
  static const _keyCompleted = 'isCompleted';
  static const _keyCreated = 'createdAt';
  static const _keyCategory = 'category';
  static const _keyPriority = 'priority';
  static const _keyDueDate = 'dueDate';
  static const _keyReminder = 'reminderAt';

  Future<void> init() async {
    _box = await Hive.openBox('tasks');
  }

  Future<List<Task>> getAll() async {
    final raw = _box.values.cast<Map>();
    return raw.map(_fromMap).toList();
  }

  Future<void> put(Task task) async {
    await _box.put(task.id, _toMap(task));
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  // ── Cache local par utilisateur (mode cloud) ──────────────────────────

  Future<Box> _open(String boxName) => Hive.openBox('tasks_$boxName');

  Future<void> cacheAll(String boxName, List<Task> tasks) async {
    final box = await _open(boxName);
    for (final task in tasks) {
      await box.put(task.id, _toMap(task));
    }
  }

  Future<List<Task>> getAllCached(String boxName) async {
    final box = await _open(boxName);
    return box.values.cast<Map>().map(_fromMap).toList();
  }

  Future<void> putIn(String boxName, Task task) async {
    final box = await _open(boxName);
    await box.put(task.id, _toMap(task));
  }

  Future<void> deleteFrom(String boxName, String id) async {
    final box = await _open(boxName);
    await box.delete(id);
  }

  Map _toMap(Task task) {
    return {
      _keyId: task.id,
      _keyTitle: task.title,
      _keyDescription: task.description,
      _keyDate: task.date.toIso8601String(),
      _keyCompleted: task.isCompleted,
      _keyCreated: (task.createdAt ?? task.date).toIso8601String(),
      _keyCategory: task.category.name,
      _keyPriority: task.priority.name,
      if (task.dueDate != null) _keyDueDate: task.dueDate!.toIso8601String(),
      if (task.reminderAt != null)
        _keyReminder: task.reminderAt!.toIso8601String(),
    };
  }

  Task _fromMap(Map map) {
    return Task(
      id: map[_keyId] as String,
      title: map[_keyTitle] as String,
      description: (map[_keyDescription] ?? '') as String,
      date: DateTime.parse(map[_keyDate] as String),
      isCompleted: (map[_keyCompleted] ?? false) as bool,
      createdAt: DateTime.tryParse(map[_keyCreated] as String),
      category: TaskCategory.fromName(map[_keyCategory] as String?),
      priority: TaskPriority.fromName(map[_keyPriority] as String?),
      dueDate: map[_keyDueDate] == null
          ? null
          : DateTime.tryParse(map[_keyDueDate] as String),
      reminderAt: map[_keyReminder] == null
          ? null
          : DateTime.tryParse(map[_keyReminder] as String),
    );
  }
}
