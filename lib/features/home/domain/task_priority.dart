import 'package:flutter/material.dart';

/// Niveau de priorité d'une tâche.
enum TaskPriority {
  low,
  medium,
  high,
  urgent;

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return const Color(0xFF4CAF50);
      case TaskPriority.medium:
        return const Color(0xFFFFB300);
      case TaskPriority.high:
        return const Color(0xFFFF7043);
      case TaskPriority.urgent:
        return const Color(0xFFE53935);
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
      case TaskPriority.urgent:
        return Icons.priority_high;
    }
  }

  /// Rang de priorité croissant (pour le tri).
  int get rank {
    switch (this) {
      case TaskPriority.low:
        return 0;
      case TaskPriority.medium:
        return 1;
      case TaskPriority.high:
        return 2;
      case TaskPriority.urgent:
        return 3;
    }
  }

  static TaskPriority fromName(String? name) {
    return TaskPriority.values.firstWhere(
      (p) => p.name == name,
      orElse: () => TaskPriority.medium,
    );
  }
}
