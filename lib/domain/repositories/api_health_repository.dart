import 'package:task_logger/core/enums/internet_connection_status.dart';

abstract class ApiHealthRepository {
  Stream<InternetConnectionStatus> get onStatusChange;
  Future<bool> get hasConnection;
}
