import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:task_logger/data/services/api_health_service/api_health_service.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/di/modules/service_module/service_module.dart';

@module
abstract class ServiceModuleImpl implements ServiceModule {
  @lazySingleton
  @override
  ApiHealthService apiHealthService(Dio dio) => ApiHealthService(dio);

  @lazySingleton
  @override
  TaskServiceAPI taskServiceAPI(Dio dio) => TaskServiceAPI(dio);

  @lazySingleton
  @override
  TaskService taskService(TaskServiceAPI taskServiceAPI) =>
      TaskService(taskServiceAPI);
}
