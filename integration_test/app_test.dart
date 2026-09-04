import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:todo_pro/main.dart';

import '../test/helpers.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(TasklyApp(repository: FakeTaskRepository()));
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('parcours complet : ajouter une tâche jusqu\'à sa validation',
      (tester) async {
    await _pumpApp(tester);

    // Ouvre l'éditeur depuis le bouton + de l'accueil.
    await tester.tap(find.byKey(const Key('home_add_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('task_title_field')),
      'Acheter du pain',
    );
    await tester.tap(find.byKey(const Key('save_task_button')));
    await tester.pumpAndSettle();

    // La tâche apparaît bien sur l'écran "Today".
    expect(find.text('Acheter du pain'), findsOneWidget);
  });

  testWidgets('navigation entre les onglets Today / Tasks / Stats / Settings',
      (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('All tasks'), findsOneWidget);

    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(find.text('Statistics'), findsWidgets);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Need help?'), findsOneWidget);
  });

  testWidgets('basculer une tâche et voir les statistiques progresser',
      (tester) async {
    await tester.pumpWidget(TasklyApp(
      repository: FakeTaskRepository([buildTask(id: 't1', title: 'Ranger')]),
    ));
    await tester.pumpAndSettle();

    // Va sur Toutes les tâches et bascule la tâche.
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('toggle_t1')));
    await tester.pumpAndSettle();

    // Va sur les statistiques : Done = 1.
    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsWidgets);
  });
}