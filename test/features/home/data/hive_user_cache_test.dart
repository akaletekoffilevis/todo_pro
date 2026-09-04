import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:todo_pro/features/home/data/datasources/hive_task_local_datasource.dart';
import 'package:todo_pro/features/home/domain/task.dart';

Future<Directory> _tempDir() async {
  return Directory.systemTemp.createTemp('hive_user_cache');
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await _tempDir();
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  final userATask = Task(
    id: 'a1',
    title: 'Tâche d\'Alice',
    date: DateTime(2026, 5, 2, 18, 0),
  );
  final userBTask = Task(
    id: 'b1',
    title: 'Tâche de Bob',
    date: DateTime(2026, 5, 2, 18, 0),
  );

  test("chaque utilisateur ne lit que son propre cache local", () async {
    final ds = HiveTaskLocalDatasource();
    await ds.init();

    await ds.putIn('tasks_userA', userATask);
    await ds.putIn('tasks_userB', userBTask);

    final userA = await ds.getAllCached('tasks_userA');
    final userB = await ds.getAllCached('tasks_userB');

    expect(userA.map((t) => t.id), ['a1']);
    expect(userB.map((t) => t.id), ['b1']);
    expect(userA.single.title, "Tâche d'Alice");
  });

  test('cacheAll remplace le cache par le cloud, deleteFrom retire une tâche',
      () async {
    final ds = HiveTaskLocalDatasource();
    await ds.init();

    final cloudTasks = [
      userATask,
      Task(
        id: 'a2',
        title: 'Deuxième tâche',
        date: DateTime(2026, 5, 3, 9, 0),
      ),
    ];

    await ds.cacheAll('tasks_userA', cloudTasks);
    var cached = await ds.getAllCached('tasks_userA');
    expect(cached.length, 2);

    await ds.deleteFrom('tasks_userA', 'a1');
    cached = await ds.getAllCached('tasks_userA');
    expect(cached.map((t) => t.id), ['a2']);
  });
}