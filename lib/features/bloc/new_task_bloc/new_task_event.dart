import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_task_event.freezed.dart';

@freezed
abstract class NewTaskEvent with _$NewTaskEvent {
  const factory NewTaskEvent({
    required String title,
    required String description,
    required bool completed,
    DateTime? dateTime,
  }) = _NewTaskEvent;
}
