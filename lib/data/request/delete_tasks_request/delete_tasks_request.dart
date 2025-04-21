import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/data/request/base_request.dart';

part 'delete_tasks_request.freezed.dart';

part 'delete_tasks_request.g.dart';

@Freezed(equal: false)
abstract class DeleteTasksRequest extends BaseRequest
    with _$DeleteTasksRequest {
  DeleteTasksRequest._();

  @JsonSerializable(explicitToJson: true)
  factory DeleteTasksRequest({
    @Default([]) List<String> ids,
  }) = _DeleteTasksRequest;

  factory DeleteTasksRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteTasksRequestFromJson(json);
}
