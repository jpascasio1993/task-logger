import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/task/create_tasks.dart';
import 'package:task_logger/domain/usecases/task/delete_tasks.dart';
import 'package:task_logger/domain/usecases/task/get_tasks.dart';
import 'package:task_logger/domain/usecases/task/sync_local_tasks.dart';
import 'package:task_logger/domain/usecases/task/update_tasks.dart';
import 'package:task_logger/domain/usecases/task/watch_tasks.dart';

abstract class UsecaseModule {
  GetTasks getTasks(TaskRepository taskRepository);
  DeleteTasks deleteTasks(TaskRepository taskRepository);
  CreateTasks createTasks(TaskRepository taskRepository);
  UpdateTasks updateTasks(TaskRepository taskRepository);
  WatchTasks watchTasks(TaskRepository taskRepository);
  SyncLocalTasks syncLocalTasks(
      TaskRepository taskRepository, GetTasks getTasks);
}
