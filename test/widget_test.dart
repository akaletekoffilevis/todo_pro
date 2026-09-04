import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_pro/main.dart';
import 'package:todo_pro/features/home/domain/task_repository.dart';

import 'helpers.dart';

Widget buildApp({TaskRepository? repository}) {
  return TasklyApp(repository: repository ?? FakeTaskRepository());
}

void main() {
  testWidgets('affiche l’accueil avec l’horloge et le tagline',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Organize your day, achieve more'), findsOneWidget);
    expect(find.byIcon(Icons.today), findsOneWidget);
  });

  testWidgets('ajoute une tâche via l’écran éditeur', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final repo = FakeTaskRepository();
    await tester.pumpWidget(buildApp(repository: repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home_add_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('task_title_field')),
      'Ma nouvelle tâche',
    );
    await tester.tap(find.byKey(const Key('save_task_button')));
    await tester.pumpAndSettle();

    final tasks = await repo.getTasks();
    expect(tasks.length, 1);
    expect(tasks.first.title, 'Ma nouvelle tâche');
  });

  testWidgets('affiche les tâches dans l’écran Toutes les tâches',
      (tester) async {
    final repo = FakeTaskRepository([
      buildTask(id: '1', title: 'Faire les courses'),
    ]);
    await tester.pumpWidget(buildApp(repository: repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();

    expect(find.text('Faire les courses'), findsOneWidget);
  });

  testWidgets('affiche l’écran Statistiques', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();

    expect(find.text('Statistics'), findsWidgets);
  });

  testWidgets('bascule la langue vers le français via les réglages',
      (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Sélectionne FR dans le segmented button.
    await tester.tap(find.text('FR'));
    await tester.pumpAndSettle();

    // Le titre des réglages devient "Réglages" (titre + onglet nav).
    expect(find.text('Réglages'), findsWidgets);
  });
}
