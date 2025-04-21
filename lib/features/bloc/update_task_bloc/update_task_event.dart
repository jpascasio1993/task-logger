import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_task_event.freezed.dart';

@freezed
abstract class UpdateTaskEvent with _$UpdateTaskEvent {
  const factory UpdateTaskEvent({
    required String id,
    String? description,
    String? title,
    DateTime? dateTime,
    bool? completed,
  }) = _UpdateTaskEvent;
}
