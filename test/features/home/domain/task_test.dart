import 'package:flutter_test/flutter_test.dart';

import 'package:todo_pro/features/home/domain/task.dart';

void main() {
  group('Task', () {
    final date = DateTime(2026, 5, 1, 10, 30);

    test('copyWith modifie uniquement les champs fournis', () {
      final t = Task(id: '1', title: 'Titre', date: date);
      final updated = t.copyWith(title: 'Nouveau', isCompleted: true);

      expect(updated.title, 'Nouveau');
      expect(updated.isCompleted, true);
      expect(updated.description, '');
      expect(updated.date, date);
      expect(updated.id, '1');
    });

    test('copyWith préserve les valeurs non modifiées', () {
      final t = Task(
        id: '2',
        title: 'A',
        description: 'B',
        date: date,
      );
      final updated = t.copyWith();
      expect(updated.title, 'A');
      expect(updated.description, 'B');
      expect(updated.date, date);
      expect(updated.isCompleted, false);
    });

    test('equatable: deux tâches identiques sont égales', () {
      final a = Task(id: '1', title: 'X', date: date);
      final b = Task(id: '1', title: 'X', date: date);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('equatable: deux tâches différentes ne sont pas égales', () {
      final a = Task(id: '1', title: 'X', date: date);
      final b = Task(id: '2', title: 'X', date: date);
      expect(a == b, false);
    });
  });
}
