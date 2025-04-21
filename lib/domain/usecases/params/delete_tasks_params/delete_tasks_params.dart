import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_tasks_params.freezed.dart';

@freezed
abstract class DeleteTasksParams with _$DeleteTasksParams {
  const factory DeleteTasksParams({
    @Default([]) List<String> ids,
  }) = _DeleteTasksParams;
}
