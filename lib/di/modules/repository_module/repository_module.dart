import 'package:task_logger/data/database/dao/task_dao/task_dao.dart';
import 'package:task_logger/data/services/api_health_service/api_health_service.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/domain/repositories/api_health_repository.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';

abstract class RepositoryModule {
  ApiHealthRepository apiHealthRepository(ApiHealthService apiHealthService);
  TaskRepository taskRepository(TaskService taskService, TaskDao taskDao);
}
