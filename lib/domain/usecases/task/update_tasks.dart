import 'package:task_logger/core/extensions/string_extension.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/update_task_result/update_task_result.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/update_tasks_params/update_tasks_params.dart';
import 'package:task_logger/domain/usecases/usecase.dart';

class UpdateTasks
    implements UseCase<BaseResponse<UpdateTaskResult>, UpdateTasksParams> {
  UpdateTasks(this._taskRepository);

  final TaskRepository _taskRepository;

  @override
  Future<Result<BaseResponse<UpdateTaskResult>>> call(
      UpdateTasksParams params) async {
    final result = await _taskRepository.updateTasks(params);
    return switch (result) {
      ResultSuccess() => result,
      ResultError(:final message) => result.copyWith(
          message: message.isNullOrEmpty
              ? 'Failed to update tasks. Try again later'
              : message),
    };
  }
}
