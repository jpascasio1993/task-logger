import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_task_view_state_event.freezed.dart';

@freezed
abstract class FormTaskViewStateEvent with _$FormTaskViewStateEvent {
  const factory FormTaskViewStateEvent.title(String? title) =
      FormTaskViewStateEventTitle;
  const factory FormTaskViewStateEvent.description(String? description) =
      FormTaskViewStateEventDescription;
  const factory FormTaskViewStateEvent.completed(bool? completed) =
      FormTaskViewStateEventCompleted;
  const factory FormTaskViewStateEvent.dateTime(DateTime? dateTime) =
      FormTaskViewStateEventDateTime;
}
