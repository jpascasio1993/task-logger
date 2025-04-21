import 'package:task_logger/domain/models/result/result.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}
