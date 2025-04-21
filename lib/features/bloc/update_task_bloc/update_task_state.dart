import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/core/utils/dio/exceptions/base_exception.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/domain/models/update_task_result/update_task_result.dart';

part 'update_task_state.freezed.dart';

@freezed
abstract class UpdateTaskState with _$UpdateTaskState {
  const factory UpdateTaskState({
    BaseResponse<UpdateTaskResult>? updateTaskResult,
    @Default(false) bool isLoading,
    BaseException? exception,
  }) = _UpdateTaskState;
}
