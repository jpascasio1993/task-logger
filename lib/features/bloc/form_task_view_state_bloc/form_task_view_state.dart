import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_task_view_state.freezed.dart';

@freezed
abstract class FormTaskViewState with _$FormTaskViewState {
  const factory FormTaskViewState({
    String? title,
    String? description,
    @Default(false) bool completed,
    DateTime? dateTime,
  }) = _FormTaskViewState;
}
