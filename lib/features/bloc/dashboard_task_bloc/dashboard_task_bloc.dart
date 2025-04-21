import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_logger/core/utils/bloc/transformers.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/usecases/params/delete_tasks_params/delete_tasks_params.dart';
import 'package:task_logger/domain/usecases/params/get_tasks_params/get_tasks_params.dart';
import 'package:task_logger/domain/usecases/task/delete_tasks.dart';
import 'package:task_logger/domain/usecases/task/get_tasks.dart';
import 'package:task_logger/domain/usecases/task/sync_local_tasks.dart';
import 'package:task_logger/domain/usecases/task/watch_tasks.dart';
import 'package:task_logger/features/bloc/base_bloc.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_event.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_state.dart';

class DashboardTaskBloc
    extends BaseBloc<DashboardTaskEvent, DashboardTaskState> {
  DashboardTaskBloc(
      this._getTasks, this._deleteTasks, this._watchTasks, this._syncLocalTasks)
      : super(const DashboardTaskState()) {
    on<DashboardTaskEventGetTasks>(_onGetTasks,
        transformer: debounceDroppable(const Duration(milliseconds: 350)));
    on<DashboardTaskEventGetTasksFromRemote>(_onGetTasksFromRemote,
        transformer: debounceDroppable(const Duration(milliseconds: 350)));
    on<DashboardTaskEventDelete>(_onDelete,
        transformer: debounceDroppable(const Duration(milliseconds: 350)));
    on<DashboardTaskEventWatchTasks>(_onWatchTasks,
        transformer: debounceDroppable(const Duration(milliseconds: 350)));
    on<DashboardTaskEventWatchTasksUpdateTaskList>(_onUpdateTaskList,
        transformer: debounceDroppable(const Duration(milliseconds: 350)));
  }

  final GetTasks _getTasks;
  final DeleteTasks _deleteTasks;
  final WatchTasks _watchTasks;

  final SyncLocalTasks _syncLocalTasks;

  late Stream<List<Task>>? _streamTasks;

  StreamSubscription<List<Task>>? _streamSubscriptionTasks;

  Future<void> _onGetTasksFromRemote(DashboardTaskEventGetTasksFromRemote event,
      Emitter<DashboardTaskState> emit) async {
    await super.run(() async {
      final res = await _syncLocalTasks(GetTasksParams(
        title: event.query,
        description: event.query,
        id: event.query,
        dateTime: event.query,
        completed: bool.tryParse(event.query ?? ''),
      ));

      if (res is ResultError<bool>) {
        Error.throwWithStackTrace(
            res.exception, res.stackTrace ?? StackTrace.current);
      }
    },
        onProcess: (isLoading, exception) => emit(
              state.copyWith(
                  getTasksLoading: isLoading, getTasksException: exception),
            ),
        onError: (isLoading, exception) => emit(
              state.copyWith(
                  getTasksLoading: isLoading, getTasksException: exception),
            ));
  }

  Future<void> _onWatchTasks(DashboardTaskEventWatchTasks event,
      Emitter<DashboardTaskState> emit) async {
    await super.run(() async {
      unawaited(_streamSubscriptionTasks?.cancel());

      _streamSubscriptionTasks = null;

      final taskStream = await _watchTasks();

      _streamTasks = (taskStream as ResultSuccess<Stream<List<Task>>>).data;

      _streamSubscriptionTasks = _streamTasks!.distinct().listen((tasks) {
        add(DashboardTaskEvent.updateTaskList(tasks));
      });
    },
        onProcess: (isLoading, exception) => emit(
              state.copyWith(
                  watchTasksLoading: isLoading, watchTasksException: exception),
            ),
        onError: (isLoading, exception) => emit(
              state.copyWith(
                  watchTasksLoading: isLoading, watchTasksException: exception),
            ));
  }

  Future<void> _onUpdateTaskList(
      DashboardTaskEventWatchTasksUpdateTaskList event,
      Emitter<DashboardTaskState> emit) async {
    emit(state.copyWith(tasks: event.tasks));
  }

  Future<void> _onGetTasks(DashboardTaskEventGetTasks event,
      Emitter<DashboardTaskState> emit) async {
    await super.run(() async {
      final res = await _getTasks(GetTasksParams(
        title: event.query,
        description: event.query,
        id: event.query,
        dateTime: event.query,
        completed: bool.tryParse(event.query ?? ''),
      ));

      switch (res) {
        case ResultSuccess(:final data):
          emit(state.copyWith(tasks: data));
        case ResultError(:final exception, :final stackTrace):
          Error.throwWithStackTrace(
              exception, stackTrace ?? StackTrace.current);
      }
    },
        onProcess: (isLoading, exception) => emit(
              state.copyWith(
                  getTasksLoading: isLoading, getTasksException: exception),
            ),
        onError: (isLoading, exception) => emit(
              state.copyWith(
                  getTasksLoading: isLoading, getTasksException: exception),
            ));
  }

  Future<void> _onDelete(
      DashboardTaskEventDelete event, Emitter<DashboardTaskState> emit) async {
    await super.run(() async {
      final res = await _deleteTasks(DeleteTasksParams(ids: event.ids));

      switch (res) {
        case ResultSuccess(:final data):
          emit(state.copyWith(deleteTaskResult: data));
        case ResultError(:final exception, :final stackTrace):
          Error.throwWithStackTrace(
              exception, stackTrace ?? StackTrace.current);
      }
    },
        onProcess: (isLoading, exception) => emit(
              state.copyWith(
                  deleteTaskLoading: isLoading, deleteTaskException: exception),
            ),
        onError: (isLoading, exception) => emit(
              state.copyWith(
                  deleteTaskLoading: isLoading, deleteTaskException: exception),
            ));
  }

  @override
  Future<void> close() async {
    await _streamSubscriptionTasks?.cancel();
    return super.close();
  }
}
