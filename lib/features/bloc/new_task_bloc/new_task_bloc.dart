import 'package:task_logger/core/utils/bloc/transformers.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/usecases/params/create_tasks_params/create_tasks_params.dart';
import 'package:task_logger/domain/usecases/task/create_tasks.dart';
import 'package:task_logger/features/bloc/base_bloc.dart';
import 'package:task_logger/features/bloc/new_task_bloc/new_task_event.dart';
import 'package:task_logger/features/bloc/new_task_bloc/new_task_state.dart';

class NewTaskBloc extends BaseBloc<NewTaskEvent, NewTaskState> {
  NewTaskBloc(this._createTasks) : super(const NewTaskState()) {
    on<NewTaskEvent>((event, emit) async {
      await super.run(
        () async {
          final res = await _createTasks(CreateTasksParams(
            title: event.title,
            description: event.description,
            dateTime: event.dateTime,
            completed: event.completed,
          ));

          switch (res) {
            case ResultSuccess(:final data):
              emit(state.copyWith(createTaskResult: data));
            case ResultError(:final exception, :final stackTrace):
              Error.throwWithStackTrace(
                  exception, stackTrace ?? StackTrace.current);
          }
        },
        onProcess: (isLoading, exception) => emit(
          state.copyWith(
            isLoading: isLoading,
            exception: exception,
          ),
        ),
        onError: (isLoading, exception) =>
            emit(state.copyWith(exception: exception, isLoading: isLoading)),
      );
    }, transformer: debounceDroppable(const Duration(milliseconds: 350)));
  }

  final CreateTasks _createTasks;
}
