import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:todo_pro/features/home/data/datasources/hive_task_local_datasource.dart';
import 'package:todo_pro/features/home/data/repositories/task_repository_impl.dart';
import 'package:todo_pro/features/home/domain/task.dart';

Future<Directory> _tempDir() async {
  final dir = await Directory.systemTemp.createTemp('hive_test');
  return dir;
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

  test('le repository ajoute, lit, met à jour et supprime des tâches', () async {
    final ds = HiveTaskLocalDatasource();
    await ds.init();
    final repo = TaskRepositoryImpl(ds);

    final task = Task(
      id: '1',
      title: 'Faire les courses',
      description: 'Lait, pain, oeufs',
      date: DateTime(2026, 5, 2, 18, 0),
      createdAt: DateTime(2026, 5, 1),
    );

    expect(await repo.getTasks(), isEmpty);

    await repo.addTask(task);
    final loaded = await repo.getTasks();
    expect(loaded.length, 1);
    expect(loaded.first.title, 'Faire les courses');
    expect(loaded.first.description, 'Lait, pain, oeufs');

    await repo.updateTask(task.copyWith(isCompleted: true));
    final updated = await repo.getTasks();
    expect(updated.first.isCompleted, true);

    await repo.deleteTask('1');
    expect(await repo.getTasks(), isEmpty);
  });

  test('la datasource persiste la date et createdAt correctement', () async {
    final ds = HiveTaskLocalDatasource();
    await ds.init();

    final date = DateTime(2026, 5, 2, 18, 30);
    final created = DateTime(2026, 4, 1, 9, 15);
    await ds.put(Task(
      id: 'x',
      title: 'T',
      date: date,
      createdAt: created,
    ));

    final all = await ds.getAll();
    expect(all.first.date, date);
    expect(all.first.createdAt, created);
  });
}
