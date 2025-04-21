import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/data/dto/task_dto/task_dto.dart';
import 'package:task_logger/data/request/base_request.dart';

part 'create_tasks_request.freezed.dart';

part 'create_tasks_request.g.dart';

@Freezed(equal: false)
abstract class CreateTasksRequest extends BaseRequest
    with _$CreateTasksRequest {
  CreateTasksRequest._();

  factory CreateTasksRequest(List<TaskDTO> tasks) = _CreateTasksRequest;

  factory CreateTasksRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTasksRequestFromJson(json);
}
