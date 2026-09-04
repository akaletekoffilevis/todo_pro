import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../domain/task.dart';
import '../../domain/task_category.dart';
import '../../domain/task_priority.dart';

/// Écran d'ajout / édition avancée d'une tâche.
class TaskEditorScreen extends HookWidget {
  final Task? task;

  const TaskEditorScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titleController = useTextEditingController(text: task?.title ?? '');
    final descController = useTextEditingController(
      text: task?.description ?? '',
    );
    final date = useState<DateTime>(task?.date ?? DateTime.now());
    final category = useState<TaskCategory>(
      task?.category ?? TaskCategory.other,
    );
    final priority = useState<TaskPriority>(
      task?.priority ?? TaskPriority.medium,
    );
    final reminder = useState<DateTime?>(task?.reminderAt);
    final isEditing = task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editTask : l10n.addTask),
        actions: [
          if (isEditing)
            IconButton(
              tooltip: l10n.delete,
              onPressed: () {
                context.read<TaskBloc>().add(DeleteTask(task!.id));
                Navigator.of(context).pop(true);
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                key: const Key('task_title_field'),
                autofocus: false,
                decoration: InputDecoration(
                  labelText: l10n.taskTitle,
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                key: const Key('task_desc_field'),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.taskDescription,
                  prefixIcon: const Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              _SectionLabel(text: l10n.taskDate),
              const SizedBox(height: 8),
              _DatePickerTile(
                date: date.value,
                onChanged: (d) => date.value = d,
              ),
              const SizedBox(height: 20),
              _SectionLabel(text: l10n.taskCategory),
              const SizedBox(height: 8),
              _CategorySelector(
                selected: category.value,
                onChanged: (c) => category.value = c,
              ),
              const SizedBox(height: 20),
              _SectionLabel(text: l10n.taskPriority),
              const SizedBox(height: 8),
              _PrioritySelector(
                selected: priority.value,
                onChanged: (p) => priority.value = p,
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                key: const Key('reminder_switch'),
                secondary: const Icon(Icons.alarm),
                title: Text(l10n.setReminder),
                value: reminder.value != null,
                onChanged: (on) async {
                  if (on) {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: date.value,
                      firstDate: now,
                      lastDate: DateTime(now.year + 5),
                    );
                    if (picked != null) {
                      if (!context.mounted) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(date.value),
                      );
                      if (time != null) {
                        reminder.value = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          time.hour,
                          time.minute,
                        );
                      }
                    }
                  } else {
                    reminder.value = null;
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  key: const Key('save_task_button'),
                  onPressed: () {
                    final bloc = context.read<TaskBloc>();
                    if (titleController.text.trim().isEmpty) return;
                    if (isEditing) {
                      bloc.add(
                        UpdateTask(
                          task!.copyWith(
                            title: titleController.text.trim(),
                            description: descController.text.trim(),
                            date: date.value,
                            category: category.value,
                            priority: priority.value,
                            reminderAt: reminder.value,
                          ),
                        ),
                      );
                    } else {
                      bloc.add(
                        AddTask(
                          Task(
                            id: DateTime.now().microsecondsSinceEpoch
                                .toString(),
                            title: titleController.text.trim(),
                            description: descController.text.trim(),
                            date: date.value,
                            createdAt: DateTime.now(),
                            category: category.value,
                            priority: priority.value,
                            reminderAt: reminder.value,
                          ),
                        ),
                      );
                    }
                    Navigator.of(context).pop(true);
                  },
                  icon: const Icon(Icons.check),
                  label: Text(l10n.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _DatePickerTile({required this.date, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: const Icon(Icons.event, color: Color(0xFF6C5CE7)),
        title: Text(_format(date)),
        subtitle: Text(l10n.taskDate),
        trailing: const Icon(Icons.edit_calendar),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            if (!context.mounted) return;
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(date),
            );
            final t = time ?? TimeOfDay.fromDateTime(date);
            onChanged(
              DateTime(picked.year, picked.month, picked.day, t.hour, t.minute),
            );
          }
        },
      ),
    );
  }

  static String _format(DateTime d) {
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day}/${d.month}/${d.year} · $h:$m';
  }
}

class _CategorySelector extends StatelessWidget {
  final TaskCategory selected;
  final ValueChanged<TaskCategory> onChanged;

  const _CategorySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TaskCategory.values.map((c) {
        final isSelected = c == selected;
        return ChoiceChip(
          avatar: Icon(
            c.icon,
            size: 16,
            color: isSelected ? Colors.white : c.color,
          ),
          label: Text(_label(context, c)),
          selected: isSelected,
          selectedColor: c.color,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight: FontWeight.w600,
          ),
          onSelected: (_) => onChanged(c),
        );
      }).toList(),
    );
  }

  static String _label(BuildContext context, TaskCategory c) {
    final l10n = AppLocalizations.of(context)!;
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

class _PrioritySelector extends StatelessWidget {
  final TaskPriority selected;
  final ValueChanged<TaskPriority> onChanged;

  const _PrioritySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: TaskPriority.values.map((p) {
        final isSelected = p == selected;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              key: Key('priority_${p.name}'),
              onTap: () => onChanged(p),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? p.color : p.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? p.color : Colors.transparent,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      p.icon,
                      color: isSelected ? Colors.white : p.color,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _priorityLabel(l10n, p),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : p.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
}
