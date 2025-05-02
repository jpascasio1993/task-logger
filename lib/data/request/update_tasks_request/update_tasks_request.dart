import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/data/dto/task_dto/task_dto.dart';
import 'package:task_logger/data/request/base_request.dart';

part 'update_tasks_request.freezed.dart';

part 'update_tasks_request.g.dart';

@Freezed(equal: false)
abstract class UpdateTasksRequest extends BaseRequest
    with _$UpdateTasksRequest {
  UpdateTasksRequest._();

  @JsonSerializable(explicitToJson: true)
  factory UpdateTasksRequest({
    @Default([]) List<TaskDTO> tasks,
  }) = _UpdateTasksRequest;

  factory UpdateTasksRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTasksRequestFromJson(json);
}
