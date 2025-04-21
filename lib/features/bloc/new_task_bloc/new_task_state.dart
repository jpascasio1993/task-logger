import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/core/utils/dio/exceptions/base_exception.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/domain/models/task/task.dart';

part 'new_task_state.freezed.dart';

@freezed
abstract class NewTaskState with _$NewTaskState {
  const factory NewTaskState({
    BaseResponse<List<Task>>? createTaskResult,
    @Default(false) bool isLoading,
    BaseException? exception,
  }) = _NewTaskState;
}
