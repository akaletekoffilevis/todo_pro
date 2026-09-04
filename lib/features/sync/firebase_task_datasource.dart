import 'package:cloud_firestore/cloud_firestore.dart';

import '../home/domain/task.dart';
import '../home/domain/task_category.dart';
import '../home/domain/task_priority.dart';

/// Datasource Firestore : une sous-collection `tasks` par utilisateur.
class FirebaseTaskDatasource {
  final FirebaseFirestore _firestore;

  FirebaseTaskDatasource(this._firestore);

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

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore.collection('users').doc(uid).collection('tasks');
  }

  Future<List<Task>> getAll(String uid) async {
    final snapshot = await _collection(uid).orderBy(_keyDate).get();
    return snapshot.docs.map((doc) => _fromMap(doc.id, doc.data())).toList();
  }

  Future<void> put(String uid, Task task) async {
    await _collection(uid)
        .doc(task.id)
        .set(_toMap(task), SetOptions(merge: true));
  }

  Future<void> delete(String uid, String id) async {
    await _collection(uid).doc(id).delete();
  }

  Map<String, dynamic> _toMap(Task task) {
    return {
      _keyId: task.id,
      _keyTitle: task.title,
      _keyDescription: task.description,
      _keyDate: task.date.toUtc().toIso8601String(),
      _keyCompleted: task.isCompleted,
      _keyCreated: (task.createdAt ?? task.date).toUtc().toIso8601String(),
      _keyCategory: task.category.name,
      _keyPriority: task.priority.name,
      if (task.dueDate != null)
        _keyDueDate: task.dueDate!.toUtc().toIso8601String(),
      if (task.reminderAt != null)
        _keyReminder: task.reminderAt!.toUtc().toIso8601String(),
    };
  }

  Task _fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      title: data[_keyTitle] as String? ?? '',
      description: (data[_keyDescription] ?? '') as String,
      date: DateTime.parse(data[_keyDate] as String).toLocal(),
      isCompleted: (data[_keyCompleted] ?? false) as bool,
      createdAt: DateTime.tryParse(data[_keyCreated] as String)?.toLocal(),
      category: TaskCategory.fromName(data[_keyCategory] as String?),
      priority: TaskPriority.fromName(data[_keyPriority] as String?),
      dueDate: data[_keyDueDate] == null
          ? null
          : DateTime.tryParse(data[_keyDueDate] as String)?.toLocal(),
      reminderAt: data[_keyReminder] == null
          ? null
          : DateTime.tryParse(data[_keyReminder] as String)?.toLocal(),
    );
  }
}