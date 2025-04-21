// ignore_for_file: invalid_annotation_target, document_ignores

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/data/request/base_request.dart';

part 'get_tasks_request.freezed.dart';

part 'get_tasks_request.g.dart';

@Freezed(equal: false)
abstract class GetTasksRequest extends BaseRequest with _$GetTasksRequest {
  GetTasksRequest._();

  @JsonSerializable(explicitToJson: true)
  factory GetTasksRequest({
    @JsonKey(name: '_id') required String? id,
    String? title,
    String? description,
    String? dateTime,
    bool? completed,
  }) = _GetTasksRequest;

  factory GetTasksRequest.fromJson(Map<String, dynamic> json) =>
      _$GetTasksRequestFromJson(json);
}
