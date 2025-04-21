import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_tasks_params.freezed.dart';

@freezed
abstract class UpdateTasksParams with _$UpdateTasksParams {
  const factory UpdateTasksParams(
      {required String id,
      String? description,
      String? title,
      DateTime? dateTime,
      bool? completed}) = _UpdateTasksParams;
}
