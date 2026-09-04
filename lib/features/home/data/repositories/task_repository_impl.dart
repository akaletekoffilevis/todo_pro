import '../datasources/hive_task_local_datasource.dart';
import '../../domain/task.dart';
import '../../domain/task_repository.dart';

/// Implémentation concrète du repository basée sur le stockage local Hive.
class TaskRepositoryImpl implements TaskRepository {
  final HiveTaskLocalDatasource datasource;

  TaskRepositoryImpl(this.datasource);

  @override
  Future<List<Task>> getTasks() => datasource.getAll();

  @override
  Future<void> addTask(Task task) => datasource.put(task);

  @override
  Future<void> updateTask(Task task) => datasource.put(task);

  @override
  Future<void> deleteTask(String id) => datasource.delete(id);
}
