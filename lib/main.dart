import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:task_logger/app.dart';
import 'package:task_logger/di/injection.dart';
import 'package:task_logger/router/router.dart';
import 'package:worker_manager/worker_manager.dart';

class CustomBlocObserver extends BlocObserver {
  Logger? _logger;

  void setLogger(Logger logger) {
    _logger = logger;
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger?.e('Bloc error', error: error, stackTrace: stackTrace);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger?.i('Bloc Event: $event \n\n Bloc: ${bloc.runtimeType}');
  }

  void logUncaughtExceptions(Object error, StackTrace trace) {
    _logger?.e('Uncaught Exception: $error', error: error, stackTrace: trace);
  }

  void flutterError(FlutterErrorDetails errorDetails) {
    _logger?.d('Flutter Error: $errorDetails');
  }
}

void main() async {
  final customBlocObserver = CustomBlocObserver();

  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    HttpOverrides.global = _HttpOverrides();

    Bloc.observer = customBlocObserver;
    FlutterError.onError = customBlocObserver.flutterError;

    final getIt = initInjection(GetIt.instance);
    customBlocObserver.setLogger(getIt<Logger>());

    workerManager.log = kDebugMode;
    await workerManager.init();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) => runApp(App(
              getIt: getIt,
              router: getRouter('/'),
            )));
  }, customBlocObserver.logUncaughtExceptions);
}

class _HttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
