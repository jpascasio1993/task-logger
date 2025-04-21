import 'package:task_logger/core/extensions/string_extension.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/create_tasks_params/create_tasks_params.dart';
import 'package:task_logger/domain/usecases/usecase.dart';

class CreateTasks
    implements UseCase<BaseResponse<List<Task>>, CreateTasksParams> {
  CreateTasks(this._taskRepository);

  final TaskRepository _taskRepository;

  @override
  Future<Result<BaseResponse<List<Task>>>> call(
      CreateTasksParams params) async {
    final result = await _taskRepository.createTasks(params);
    return switch (result) {
      ResultSuccess() => result,
      ResultError(:final message) => result.copyWith(
          message: message.isNullOrEmpty
              ? 'Failed to create tasks. Try again later'
              : message),
    };
  }
}
