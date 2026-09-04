import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_pro/features/home/bloc/task_bloc.dart';
import 'package:todo_pro/features/home/bloc/task_state.dart';
import 'package:todo_pro/features/home/bloc/task_event.dart';
import 'package:todo_pro/features/home/domain/task_priority.dart';

import '../../../helpers.dart';

void main() {
  group('TaskBloc', () {
    late FakeTaskRepository repository;

    setUp(() {
      repository = FakeTaskRepository();
    });

    blocTest<TaskBloc, TaskState>(
      'charge les tâches sans erreur',
      build: () => TaskBloc(repository: repository),
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => const [
        TaskState(isLoading: true),
        TaskState(tasks: [], isLoading: false),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'charge les tâches existantes',
      setUp: () {
        repository = FakeTaskRepository([buildTask(id: 'a', title: 'Acheter')]);
      },
      build: () => TaskBloc(repository: repository),
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => [
        const TaskState(isLoading: true),
        TaskState(tasks: [buildTask(id: 'a', title: 'Acheter')], isLoading: false),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'ajoute une tâche et la reflète dans l’état',
      build: () => TaskBloc(repository: repository),
      act: (bloc) async {
        bloc.add(LoadTasks());
        bloc.add(AddTask(buildTask(id: '1', title: 'Nouvelle')));
      },
      expect: () => [
        const TaskState(isLoading: true),
        const TaskState(tasks: [], isLoading: false),
        TaskState(tasks: [buildTask(id: '1', title: 'Nouvelle')], isLoading: false),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'marque une tâche comme complétée via ToggleTask',
      setUp: () {
        repository = FakeTaskRepository([buildTask(id: '1', title: 'T')]);
      },
      build: () => TaskBloc(repository: repository),
      act: (bloc) async {
        bloc.add(LoadTasks());
        bloc.add(ToggleTask(buildTask(id: '1', title: 'T')));
      },
      expect: () => [
        const TaskState(isLoading: true),
        TaskState(tasks: [buildTask(id: '1', title: 'T')], isLoading: false),
        TaskState(
          tasks: [buildTask(id: '1', title: 'T', isCompleted: true)],
          isLoading: false,
        ),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'supprime une tâche',
      setUp: () {
        repository = FakeTaskRepository([
          buildTask(id: '1'),
          buildTask(id: '2', title: 'Garder'),
        ]);
      },
      build: () => TaskBloc(repository: repository),
      act: (bloc) async {
        bloc.add(LoadTasks());
        bloc.add(DeleteTask('1'));
      },
      expect: () => [
        const TaskState(isLoading: true),
        TaskState(
          tasks: [buildTask(id: '1'), buildTask(id: '2', title: 'Garder')],
          isLoading: false,
        ),
        TaskState(tasks: [buildTask(id: '2', title: 'Garder')], isLoading: false),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'met à jour le titre d’une tâche',
      setUp: () {
        repository = FakeTaskRepository([buildTask(id: '1', title: 'Avant')]);
      },
      build: () => TaskBloc(repository: repository),
      act: (bloc) async {
        bloc.add(LoadTasks());
        bloc.add(UpdateTask(buildTask(id: '1', title: 'Après')));
      },
      expect: () => [
        const TaskState(isLoading: true),
        TaskState(tasks: [buildTask(id: '1', title: 'Avant')], isLoading: false),
        TaskState(tasks: [buildTask(id: '1', title: 'Après')], isLoading: false),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'applique la recherche textuelle',
      build: () => TaskBloc(repository: repository),
      seed: () => TaskState(
        tasks: [buildTask(id: '1', title: 'Courses'), buildTask(id: '2', title: 'Rapport')],
      ),
      act: (bloc) => bloc.add(SetSearchQuery('cours')),
      expect: () => [
        TaskState(
          tasks: [buildTask(id: '1', title: 'Courses'), buildTask(id: '2', title: 'Rapport')],
          searchQuery: 'cours',
        ),
      ],
    );

    test('filteredTasks applique filtre priorité et tri par titre', () {
      final state = TaskState(
        tasks: [
          buildTask(id: '1', title: 'B', priority: TaskPriority.high),
          buildTask(id: '2', title: 'A', priority: TaskPriority.low),
          buildTask(id: '3', title: 'B', priority: TaskPriority.urgent),
        ],
        priorityFilter: TaskPriority.urgent,
        sortBy: TaskSortBy.title,
      );
      final result = state.filteredTasks;
      expect(result.length, 1);
      expect(result.first.id, '3');
    });

    test('filteredTasks trie par priorité (urgente d’abord)', () {
      final state = TaskState(
        tasks: [
          buildTask(id: '1', title: 'a', priority: TaskPriority.low),
          buildTask(id: '2', title: 'b', priority: TaskPriority.urgent),
        ],
        sortBy: TaskSortBy.priority,
      );
      final result = state.filteredTasks;
      expect(result.first.id, '2');
    });

    test('isOverdue est vrai pour une tâche passée non complétée', () {
      final task = buildTask(id: '1', title: 'T', date: DateTime(2000, 1, 1));
      expect(task.isOverdue, true);
    });
  });
}
