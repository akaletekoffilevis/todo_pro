import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/task.dart';
import '../../domain/task_category.dart';
import '../../domain/task_priority.dart';

/// Carte d'une tâche au design premium.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;
  final Key? checkboxKey;

  const TaskCard({
    super.key,
    required this.task,
    this.onToggle,
    this.onTap,
    this.checkboxKey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final category = task.category;
    final priority = task.priority;

    return Semantics(
      label:
          '${task.title}${task.isCompleted ? ', ${l10n.completed}' : ', ${l10n.pending}'}',
      button: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: task.isCompleted
                ? Colors.transparent
                : category.color.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Row(
            children: [
              // CheckBox circulaire personnalisée.
              GestureDetector(
                key: checkboxKey,
                onTap: onToggle,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: task.isCompleted
                      ? Icon(
                          Icons.check_circle,
                          key: const ValueKey('done'),
                          color: theme.colorScheme.primary,
                          size: 28,
                        )
                      : Container(
                          key: const ValueKey('todo'),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: category.color, width: 2),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              // Contenu : titre, description, échéance, badges.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted ? theme.disabledColor : null,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.disabledColor,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Meta-row : priorité, catégorie, échéance.
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _MetaChip(
                          color: priority.color,
                          icon: priority.icon,
                          label: _priorityLabel(l10n, priority),
                        ),
                        _MetaChip(
                          color: category.color,
                          icon: category.icon,
                          label: _categoryLabel(l10n, category),
                        ),
                        if (task.isOverdue)
                          _MetaChip(
                            color: Colors.red,
                            icon: Icons.warning_amber_rounded,
                            label: l10n.overdue,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Cheatron vers édition.
              Icon(
                Icons.chevron_right,
                color: theme.disabledColor.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
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

  static String _categoryLabel(AppLocalizations l10n, TaskCategory c) {
    switch (c) {
      case TaskCategory.personal:
        return l10n.categoryPersonal;
      case TaskCategory.work:
        return l10n.categoryWork;
      case TaskCategory.health:
        return l10n.categoryHealth;
      case TaskCategory.shopping:
        return l10n.categoryShopping;
      case TaskCategory.studies:
        return l10n.categoryStudies;
      case TaskCategory.other:
        return l10n.categoryOther;
    }
  }
}

class _MetaChip extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;

  const _MetaChip({
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
