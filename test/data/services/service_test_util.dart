import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:task_logger/core/utils/dio/transformers/background_worker_transformer.dart';

class ServiceTestUtil {
  ServiceTestUtil();

  Dio getDio([List<Interceptor>? interceptors]) => Dio()
    ..transformer = BackgroundWorkerTransformer()
    ..interceptors.addAll(interceptors ?? [QueuedInterceptor()]);

  DioAdapter getDioAdapter(Dio dio) =>
      DioAdapter(dio: dio, matcher: const UrlRequestMatcher());
}
