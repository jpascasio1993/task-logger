import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:task_logger/data/env/environment_config.dart';

abstract class CoreModule {
  BaseOptions baseOptions(EnvironmentConfig environmentConfig);
  Dio dio(BaseOptions options, List<Interceptor> interceptors);
  EnvironmentConfig environmentConfig();
  List<Interceptor> dioInterceptors();
  Logger get logger;
}
