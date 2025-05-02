import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/core/utils/dio/exceptions/base_exception.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/domain/models/delete_task_result/delete_task_result.dart';
import 'package:task_logger/domain/models/task/task.dart';

part 'dashboard_task_state.freezed.dart';

@freezed
abstract class DashboardTaskState with _$DashboardTaskState {
  const factory DashboardTaskState({
    @Default([]) List<Task> tasks,
    @Default(false) bool getTasksLoading,
    BaseException? getTasksException,
    BaseResponse<DeleteTaskResult>? deleteTaskResult,
    @Default(false) bool deleteTaskLoading,
    BaseException? deleteTaskException,
    @Default(false) bool watchTasksLoading,
    BaseException? watchTasksException,
    @Default(false) bool syncRemoteTasksLoading,
    BaseException? syncRemoteTasksException,
  }) = _DashboardTaskState;
}
