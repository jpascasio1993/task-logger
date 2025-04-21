import 'package:injectable/injectable.dart';
import 'package:task_logger/data/database/dao/task_dao/task_dao.dart';
import 'package:task_logger/data/repositories/api_health_repository_impl.dart';
import 'package:task_logger/data/repositories/task_repository_impl.dart';
import 'package:task_logger/data/services/api_health_service/api_health_service.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/di/modules/repository_module/repository_module.dart';
import 'package:task_logger/domain/repositories/api_health_repository.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';

@module
abstract class RepositoryModuleImpl implements RepositoryModule {
  @lazySingleton
  @override
  ApiHealthRepository apiHealthRepository(ApiHealthService apiHealthService) =>
      ApiHealthRepositoryImpl(
          apiHealthService,
          const ApiHealthOptions(
            checkTimeout: Duration(seconds: 5),
            checkInterval: Duration(seconds: 10),
          ));

  @lazySingleton
  @override
  TaskRepository taskRepository(TaskService taskService, TaskDao taskDao) =>
      TaskRepositoryImpl(taskService, taskDao);
}
