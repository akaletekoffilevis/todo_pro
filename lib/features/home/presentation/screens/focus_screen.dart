import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../bloc/task_state.dart';
import '../../domain/task.dart';

/// Mode focus : concentre-toi sur une tâche à la fois avec un chrono.
class FocusScreen extends HookWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Sélection locale de la tâche en cours + état du chrono.
    final currentTask = useState<Task?>(null);
    final elapsed = useState(Duration.zero);
    final running = useState(false);
    final finished = useState(false);

    useEffect(() {
      Timer? timer;
      if (running.value) {
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          elapsed.value = elapsed.value + const Duration(seconds: 1);
        });
      }
      return () => timer?.cancel();
    }, [running.value]);

    final pendingTasks = context.select<TaskState, List<Task>>(
      (state) => state.tasks.where((t) => !t.isCompleted).toList(),
    );

    void start(Task task) {
      currentTask.value = task;
      elapsed.value = Duration.zero;
      running.value = true;
      finished.value = false;
    }

    void stopAndComplete() {
      running.value = false;
      finished.value = true;
      if (currentTask.value != null) {
        context.read<TaskBloc>().add(ToggleTask(currentTask.value!));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.focusTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    l10n.focusTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Grand chrono circulaire.
              Expanded(
                child: Center(
                  child: _TimerDial(
                    elapsed: elapsed.value,
                    running: running.value,
                    onToggle: () => running.value = !running.value,
                    onReset: () => elapsed.value = Duration.zero,
                  ),
                ),
              ),
              // Tâche en cours.
              if (currentTask.value != null && !finished.value) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    currentTask.value!.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (currentTask.value == null || finished.value) ...[
                Text(
                  finished.value ? l10n.focusDone : l10n.focusHint,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (pendingTasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No pending tasks'),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pendingTasks.map((task) {
                      return ActionChip(
                        avatar: const Icon(Icons.timer),
                        label: Text(task.title),
                        onPressed: () => start(task),
                      );
                    }).toList(),
                  ),
              ] else
                FilledButton.icon(
                  onPressed: stopAndComplete,
                  icon: const Icon(Icons.check),
                  label: Text(l10n.focusDone),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerDial extends StatelessWidget {
  final Duration elapsed;
  final bool running;
  final VoidCallback onToggle;
  final VoidCallback onReset;

  const _TimerDial({
    required this.elapsed,
    required this.running,
    required this.onToggle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const SweepGradient(
              startAngle: -1.5,
              colors: [Color(0xFF6C5CE7), Color(0xFF00BFA6), Color(0xFF6C5CE7)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C5CE7).withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.scaffoldBackgroundColor,
            ),
            alignment: Alignment.center,
            child: Text(
              '$minutes:$seconds',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              tooltip: 'Reset',
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
            ),
            const SizedBox(width: 16),
            IconButton.filled(
              onPressed: onToggle,
              icon: Icon(running ? Icons.pause : Icons.play_arrow),
              iconSize: 32,
              style: IconButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ],
        ),
      ],
    );
  }
}
