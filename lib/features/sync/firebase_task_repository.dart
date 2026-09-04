import '../auth/domain/app_user.dart';
import '../home/data/datasources/hive_task_local_datasource.dart';
import '../home/domain/task.dart';
import '../home/domain/task_repository.dart';
import 'firebase_task_datasource.dart';

/// Repository "cloud-first" : Firestore est la source de vérité, Hive sert de
/// cache local (offline). Chaque utilisateur ne voit QUE ses propres tâches.
class FirebaseTaskRepository implements TaskRepository {
  final AppUser user;
  final FirebaseTaskDatasource datasource;
  final HiveTaskLocalDatasource local;

  FirebaseTaskRepository({
    required this.user,
    required this.datasource,
    required this.local,
  });

  String get _cacheKey => 'tasks_${user.uid}';

  @override
  Future<List<Task>> getTasks() async {
    try {
      final remote = await datasource.getAll(user.uid);
      await local.cacheAll(_cacheKey, remote);
      return remote;
    } catch (_) {
      return local.getAllCached(_cacheKey);
    }
  }

  @override
  Future<void> addTask(Task task) async {
    await local.putIn(_cacheKey, task);
    try {
      await datasource.put(user.uid, task);
    } catch (_) {
      // Hors-ligne : la tâche reste dans le cache local.
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    await local.putIn(_cacheKey, task);
    try {
      await datasource.put(user.uid, task);
    } catch (_) {
      // Hors-ligne.
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    await local.deleteFrom(_cacheKey, id);
    try {
      await datasource.delete(user.uid, id);
    } catch (_) {
      // Hors-ligne.
    }
  }
}