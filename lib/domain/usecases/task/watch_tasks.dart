import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/no_params/no_params.dart';
import 'package:task_logger/domain/usecases/usecase.dart';

class WatchTasks implements UseCase<Stream<List<Task>>, NoParams> {
  WatchTasks(this._taskRepository);

  final TaskRepository _taskRepository;

  @override
  Future<Result<Stream<List<Task>>>> call([NoParams? params]) {
    final res = Result.success(_taskRepository.watchTasks());
    return Future.value(res);
  }
}
