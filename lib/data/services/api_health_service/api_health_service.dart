import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_health_service.g.dart';

@RestApi()
abstract class ApiHealthService {
  factory ApiHealthService(Dio dio) => _ApiHealthService(dio);

  @GET('/api/health')
  Future<bool> isHealthy();
}
