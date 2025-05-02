import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/get_tasks_params/get_tasks_params.dart';
import 'package:task_logger/domain/usecases/task/get_tasks.dart';
import 'package:task_logger/domain/usecases/usecase.dart';

class SyncLocalTasks implements UseCase<bool, GetTasksParams> {
  SyncLocalTasks(this._taskRepository, this._getTasks);

  final TaskRepository _taskRepository;
  final GetTasks _getTasks;

  @override
  Future<Result<bool>> call(GetTasksParams params) async {
    final resultTasksFromRemote = await _getTasks(params);
    if (resultTasksFromRemote is ResultError<List<Task>>) {
      return Result.error(resultTasksFromRemote.message,
          exception: resultTasksFromRemote.exception,
          stackTrace: resultTasksFromRemote.stackTrace);
    }
    final res = await _taskRepository.syncLocalTasks(
        (resultTasksFromRemote as ResultSuccess<List<Task>>).data);

    return res;
  }
}
