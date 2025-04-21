import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/domain/models/task/task.dart';

part 'dashboard_task_event.freezed.dart';

@freezed
sealed class DashboardTaskEvent with _$DashboardTaskEvent {
  const factory DashboardTaskEvent.delete(List<String> ids) =
      DashboardTaskEventDelete;
  const factory DashboardTaskEvent.getTasks([String? query]) =
      DashboardTaskEventGetTasks;
  const factory DashboardTaskEvent.getTasksFromRemote([String? query]) =
      DashboardTaskEventGetTasksFromRemote;
  const factory DashboardTaskEvent.watchTasks([String? query]) =
      DashboardTaskEventWatchTasks;
  const factory DashboardTaskEvent.updateTaskList(List<Task> tasks) =
      DashboardTaskEventWatchTasksUpdateTaskList;
}
