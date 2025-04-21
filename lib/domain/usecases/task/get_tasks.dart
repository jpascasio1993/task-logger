import 'package:task_logger/core/extensions/string_extension.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/get_tasks_params/get_tasks_params.dart';
import 'package:task_logger/domain/usecases/usecase.dart';

class GetTasks implements UseCase<List<Task>, GetTasksParams> {
  GetTasks(this._taskRepository);

  final TaskRepository _taskRepository;

  @override
  Future<Result<List<Task>>> call(GetTasksParams params) async {
    final result = await _taskRepository.getTasks(params);
    return switch (result) {
      ResultSuccess() => result,
      ResultError(:final message) => result.copyWith(
          message: message.isNullOrEmpty
              ? 'Failed to retrieve tasks. Try again later'
              : message),
    };
  }
}
