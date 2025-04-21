import 'package:dio/dio.dart';
import 'package:task_logger/data/services/api_health_service/api_health_service.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';

abstract class ServiceModule {
  ApiHealthService apiHealthService(Dio dio);
  TaskServiceAPI taskServiceAPI(Dio dio);
  TaskService taskService(TaskServiceAPI taskServiceAPI);
}
