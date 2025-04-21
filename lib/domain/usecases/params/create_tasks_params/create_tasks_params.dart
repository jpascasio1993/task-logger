import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_tasks_params.freezed.dart';

@freezed
abstract class CreateTasksParams with _$CreateTasksParams {
  const factory CreateTasksParams(
      {String? description,
      String? title,
      DateTime? dateTime,
      bool? completed}) = _CreateTasksParams;
}
