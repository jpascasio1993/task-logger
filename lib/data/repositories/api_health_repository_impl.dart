import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:task_logger/core/enums/internet_connection_status.dart';
import 'package:task_logger/data/services/api_health_service/api_health_service.dart';
import 'package:task_logger/domain/repositories/api_health_repository.dart';

class ApiHealthOptions {
  const ApiHealthOptions(
      {this.checkInterval = const Duration(seconds: 2),
      this.checkTimeout = const Duration(seconds: 10)});

  final Duration checkInterval;
  final Duration checkTimeout;
}

class ApiHealthRepositoryImpl implements ApiHealthRepository {
  ApiHealthRepositoryImpl(this._apiHealthService, this._apiHealthOptions) {
    _internetStatusController
      ..onListen = _emitStatusUpdate
      ..onCancel = () {
        /// stops internal periodic internet checker when [_internetStatusController] is cancelled
        unawaited(_internetStatusController.close());
        unawaited(_internetCheckerSubscription?.cancel());
      };
  }

  final ApiHealthService _apiHealthService;
  final ApiHealthOptions _apiHealthOptions;
  final StreamController<InternetConnectionStatus> _internetStatusController =
      StreamController<InternetConnectionStatus>.broadcast();

  late StreamSubscription<dynamic>? _internetCheckerSubscription;

  void _emitStatusUpdate() {
    _internetCheckerSubscription =
        Stream.periodic(_apiHealthOptions.checkInterval)
            .switchMap((_) => Stream<bool>.fromFuture(hasConnection))
            .distinct()
            .listen((connected) {
      _internetStatusController.add(connected
          ? InternetConnectionStatus.connected
          : InternetConnectionStatus.disconnected);
    }, onError: (_) {
      _internetStatusController.add(InternetConnectionStatus.disconnected);
    });
  }

  @override
  Stream<InternetConnectionStatus> get onStatusChange =>
      _internetStatusController.stream.asBroadcastStream();

  @override
  Future<bool> get hasConnection => _apiHealthService
      .isHealthy()
      .timeout(_apiHealthOptions.checkTimeout)
      .catchError((_) => false);
}
