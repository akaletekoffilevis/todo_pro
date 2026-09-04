import 'package:equatable/equatable.dart';

import 'task_category.dart';
import 'task_priority.dart';

/// Entité métier représentant une tâche enrichie.
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isCompleted;
  final DateTime? createdAt;
  final TaskCategory category;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime? reminderAt;

  const Task({
    required this.id,
    required this.title,
    required this.date,
    this.description = '',
    this.isCompleted = false,
    this.createdAt,
    this.category = TaskCategory.other,
    this.priority = TaskPriority.medium,
    this.dueDate,
    this.reminderAt,
  });

  bool get isOverdue =>
      !isCompleted && date.isBefore(DateTime.now()) && !_isToday(date);

  bool get hasReminder => reminderAt != null;

  Task copyWith({
    String? title,
    String? description,
    DateTime? date,
    bool? isCompleted,
    TaskCategory? category,
    TaskPriority? priority,
    DateTime? dueDate,
    DateTime? reminderAt,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      reminderAt: reminderAt ?? this.reminderAt,
    );
  }

  static bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    date,
    isCompleted,
    category,
    priority,
    dueDate,
    reminderAt,
  ];
}
