import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_tasks_params.freezed.dart';

@freezed
abstract class CreateTasksParams with _$CreateTasksParams {
  const factory CreateTasksParams(
      {required String description,
      required String title,
      DateTime? dateTime,
      bool? completed}) = _CreateTasksParams;
}
