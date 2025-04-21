import 'package:injectable/injectable.dart';
import 'package:task_logger/di/modules/usecase_module/usecase_module.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/task/create_tasks.dart';
import 'package:task_logger/domain/usecases/task/delete_tasks.dart';
import 'package:task_logger/domain/usecases/task/get_tasks.dart';
import 'package:task_logger/domain/usecases/task/sync_local_tasks.dart';
import 'package:task_logger/domain/usecases/task/update_tasks.dart';
import 'package:task_logger/domain/usecases/task/watch_tasks.dart';

@module
abstract class UsecaseModuleImpl implements UsecaseModule {
  @lazySingleton
  @override
  GetTasks getTasks(TaskRepository taskRepository) => GetTasks(taskRepository);

  @lazySingleton
  @override
  DeleteTasks deleteTasks(TaskRepository taskRepository) =>
      DeleteTasks(taskRepository);

  @lazySingleton
  @override
  CreateTasks createTasks(TaskRepository taskRepository) =>
      CreateTasks(taskRepository);

  @lazySingleton
  @override
  UpdateTasks updateTasks(TaskRepository taskRepository) =>
      UpdateTasks(taskRepository);

  @lazySingleton
  @override
  WatchTasks watchTasks(TaskRepository taskRepository) =>
      WatchTasks(taskRepository);

  @lazySingleton
  @override
  SyncLocalTasks syncLocalTasks(
          TaskRepository taskRepository, GetTasks getTasks) =>
      SyncLocalTasks(taskRepository, getTasks);
}
