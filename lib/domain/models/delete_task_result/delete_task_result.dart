import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/domain/models/base_model.dart';

part 'delete_task_result.freezed.dart';

part 'delete_task_result.g.dart';

@freezed
abstract class DeleteTaskResult extends BaseModel with _$DeleteTaskResult {
  DeleteTaskResult._();

  @JsonSerializable(explicitToJson: true)
  factory DeleteTaskResult({
    @Default(false) bool acknowledged,
    @Default(0) int deletedCount,
  }) = _DeleteTaskResult;

  factory DeleteTaskResult.fromJson(Map<String, dynamic> json) =>
      _$DeleteTaskResultFromJson(json);
}
