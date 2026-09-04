import 'package:flutter/material.dart';

/// Catégorie d'une tâche, avec icône et couleur associées.
enum TaskCategory {
  personal,
  work,
  health,
  shopping,
  studies,
  other;

  IconData get icon {
    switch (this) {
      case TaskCategory.personal:
        return Icons.person;
      case TaskCategory.work:
        return Icons.business_center;
      case TaskCategory.health:
        return Icons.favorite;
      case TaskCategory.shopping:
        return Icons.shopping_bag;
      case TaskCategory.studies:
        return Icons.school;
      case TaskCategory.other:
        return Icons.star;
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.personal:
        return const Color(0xFF7C4DFF);
      case TaskCategory.work:
        return const Color(0xFF2979FF);
      case TaskCategory.health:
        return const Color(0xFFFF3D71);
      case TaskCategory.shopping:
        return const Color(0xFF00BFA6);
      case TaskCategory.studies:
        return const Color(0xFFFF6D00);
      case TaskCategory.other:
        return const Color(0xFF757575);
    }
  }

  static TaskCategory fromName(String? name) {
    return TaskCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => TaskCategory.other,
    );
  }
}
