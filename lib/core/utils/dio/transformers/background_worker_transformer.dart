import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_logger/data/request/base_request.dart';
import 'package:worker_manager/worker_manager.dart';

/// [BackgroundWorkerTransformer] will do the deserialization of JSON
/// in a background isolate if possible.
class BackgroundWorkerTransformer extends SyncTransformer {
  BackgroundWorkerTransformer() : super(jsonDecodeCallback: _decodeJson);

  @override
  Future<String> transformRequest(RequestOptions options) async {
    /// TODO: temporary bug fix for retrofit_generator
    /// not generating serialization for classes annotated with [@Body] that
    /// is on another path
    if (options.data is BaseRequest) {
      options.data = await workerManager
          .execute(() => (options.data as BaseRequest).toJson());
    }
    return super.transformRequest(options);
  }
}

FutureOr<dynamic> _decodeJson(String text) {
  // Taken from https://github.com/flutter/flutter/blob/135454af32477f815a7525073027a3ff9eff1bfd/packages/flutter/lib/src/services/asset_bundle.dart#L87-L93
  // 50 KB of data should take 2-3 ms to parse on a Moto G4, and about 400 μs
  // on a Pixel 4.
  if (text.codeUnits.length < 50 * 1024) {
    return workerManager.execute(() => jsonDecode(text));
  }
  // For strings larger than 50 KB, run the computation in an isolate to
  // avoid causing main thread jank.
  return workerManager.execute(() => jsonDecode(text));
}
