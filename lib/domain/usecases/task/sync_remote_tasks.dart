import 'package:task_logger/domain/models/delete_task_result/delete_task_result.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/models/update_task_result/update_task_result.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/no_params/no_params.dart';
import 'package:task_logger/domain/usecases/usecase.dart';

class SyncRemoteTasks implements UseCase<bool, NoParams> {
  SyncRemoteTasks(this._taskRepository);

  final TaskRepository _taskRepository;

  @override
  Future<Result<bool>> call([NoParams? params]) async {
    final syncLocallyCreatedTasks =
        await _taskRepository.syncLocallyCreatedTasks();
    final syncDeletedTasks = await _taskRepository.syncLocallyDeletedTasks();
    final syncUpdatedTasks = await _taskRepository.syncLocallyUpdatedTasks();
    if (syncLocallyCreatedTasks is ResultError<List<Task>>) {
      final result = syncLocallyCreatedTasks as ResultError<List<Task>>;
      return Result.error(result.message,
          exception: result.exception, stackTrace: result.stackTrace);
    }

    if (syncDeletedTasks is ResultError<DeleteTaskResult>) {
      final result = syncDeletedTasks as ResultError<DeleteTaskResult>;
      return Result.error(result.message,
          exception: result.exception, stackTrace: result.stackTrace);
    }

    if (syncUpdatedTasks is ResultError<UpdateTaskResult>) {
      final result = syncUpdatedTasks as ResultError<UpdateTaskResult>;
      return Result.error(result.message,
          exception: result.exception, stackTrace: result.stackTrace);
    }

    return const Result.success(true);
  }
}
