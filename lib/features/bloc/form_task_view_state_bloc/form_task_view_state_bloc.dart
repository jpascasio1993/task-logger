import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_logger/core/utils/bloc/transformers.dart';
import 'package:task_logger/features/bloc/form_task_view_state_bloc/form_task_view_state.dart';
import 'package:task_logger/features/bloc/form_task_view_state_bloc/form_task_view_state_event.dart';

class FormTaskViewStateBloc
    extends Bloc<FormTaskViewStateEvent, FormTaskViewState> {
  FormTaskViewStateBloc() : super(const FormTaskViewState()) {
    on<FormTaskViewStateEventTitle>((event, emit) {
      emit(state.copyWith(title: event.title));
    }, transformer: debounce(const Duration(milliseconds: 350)));
    on<FormTaskViewStateEventDescription>((event, emit) {
      emit(state.copyWith(description: event.description));
    }, transformer: debounce(const Duration(milliseconds: 350)));
    on<FormTaskViewStateEventCompleted>((event, emit) {
      emit(state.copyWith(completed: event.completed ?? false));
    }, transformer: debounce(const Duration(milliseconds: 350)));
    on<FormTaskViewStateEventDateTime>((event, emit) {
      emit(state.copyWith(dateTime: event.dateTime));
    }, transformer: debounce(const Duration(milliseconds: 350)));
  }
}
