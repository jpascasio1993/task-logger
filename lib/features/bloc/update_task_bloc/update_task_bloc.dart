import 'package:task_logger/core/utils/bloc/transformers.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/usecases/params/update_tasks_params/update_tasks_params.dart';
import 'package:task_logger/domain/usecases/task/update_tasks.dart';
import 'package:task_logger/features/bloc/base_bloc.dart';
import 'package:task_logger/features/bloc/update_task_bloc/update_task_event.dart';
import 'package:task_logger/features/bloc/update_task_bloc/update_task_state.dart';

class UpdateTaskBloc extends BaseBloc<UpdateTaskEvent, UpdateTaskState> {
  UpdateTaskBloc(this._updateTasks) : super(const UpdateTaskState()) {
    on<UpdateTaskEvent>((event, emit) async {
      await super.run(
        () async {
          final res = await _updateTasks(UpdateTasksParams(
            id: event.id,
            title: event.title,
            description: event.description,
            dateTime: event.dateTime,
            completed: event.completed,
          ));
          switch (res) {
            case ResultSuccess(:final data):
              emit(state.copyWith(updateTaskResult: data));
            case ResultError(:final exception, :final stackTrace):
              Error.throwWithStackTrace(
                  exception, stackTrace ?? StackTrace.current);
          }
        },
        onProcess: (isLoading, exception) => emit(state.copyWith(
          isLoading: isLoading,
          exception: exception,
        )),
        onError: (isLoading, exception) =>
            emit(state.copyWith(isLoading: isLoading, exception: exception)),
      );
    }, transformer: debounceDroppable(const Duration(milliseconds: 350)));
  }

  final UpdateTasks _updateTasks;
}
