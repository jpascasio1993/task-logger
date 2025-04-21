import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_tasks_params.freezed.dart';

@freezed
abstract class GetTasksParams with _$GetTasksParams {
  const factory GetTasksParams(
      {String? description,
      String? id,
      String? title,
      String? dateTime,
      bool? completed}) = _GetTasksParams;
}
