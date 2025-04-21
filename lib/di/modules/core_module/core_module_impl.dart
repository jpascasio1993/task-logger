import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:task_logger/core/utils/dio/transformers/background_worker_transformer.dart';
import 'package:task_logger/data/env/environment_config.dart';
import 'package:task_logger/di/modules/core_module/core_module.dart';

@module
abstract class CoreModulesImpl implements CoreModule {
  @lazySingleton
  @override
  BaseOptions baseOptions(EnvironmentConfig environmentConfig) => BaseOptions(
        baseUrl: environmentConfig.baseUrl,
        connectTimeout: const Duration(minutes: 10),
        receiveTimeout: const Duration(minutes: 10),
        responseType: ResponseType.json,
        sendTimeout: const Duration(seconds: 15),
        contentType: ContentType.json.toString(),
      );

  @lazySingleton
  @override
  Dio dio(BaseOptions options, List<Interceptor> interceptors) {
    final dio = Dio()
      ..options = options
      ..transformer = BackgroundWorkerTransformer()
      ..interceptors.addAll(interceptors);

    final httpClientAdapter = dio.httpClientAdapter;

    // TODO: Remove this after SSL certificate is fixed..
    if (httpClientAdapter is IOHttpClientAdapter) {
      httpClientAdapter.createHttpClient = () {
        final client = HttpClient()
          ..idleTimeout = const Duration(seconds: 3)
          ..badCertificateCallback = ((cert, host, port) => true);
        return client;
      };
    }

    return dio;
  }

  @lazySingleton
  @override
  EnvironmentConfig environmentConfig() => EnvironmentConfig();

  @lazySingleton
  @override
  List<Interceptor> dioInterceptors() => [
        QueuedInterceptor(),
        PrettyDioLogger(
          requestBody: kDebugMode,
          responseBody: kDebugMode,
          error: kDebugMode,
          compact: false,
          maxWidth: 220,
        ),
      ];

  @lazySingleton
  @override
  Logger get logger => Logger(
          printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 220,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ));
}
