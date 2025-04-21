import 'package:task_logger/core/extensions/string_extension.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/domain/models/delete_task_result/delete_task_result.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/delete_tasks_params/delete_tasks_params.dart';
import 'package:task_logger/domain/usecases/usecase.dart';

class DeleteTasks
    implements UseCase<BaseResponse<DeleteTaskResult>, DeleteTasksParams> {
  DeleteTasks(this._taskRepository);

  final TaskRepository _taskRepository;

  @override
  Future<Result<BaseResponse<DeleteTaskResult>>> call(
      DeleteTasksParams params) async {
    final result = await _taskRepository.deleteTasks(params);
    return switch (result) {
      ResultSuccess() => result,
      ResultError(:final message) => result.copyWith(
          message: message.isNullOrEmpty
              ? 'Failed to delete tasks. Try again later'
              : message),
    };
  }
}
