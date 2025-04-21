import 'package:flutter/foundation.dart';
import 'package:worker_manager/worker_manager.dart';

Future<R> compute<M, R>(ComputeCallback<M, R> callback, M message,
    {String? debugLabel}) {
  return workerManager.execute(() => callback(message));
}
