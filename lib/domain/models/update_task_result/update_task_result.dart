import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/domain/models/base_model.dart';

part 'update_task_result.freezed.dart';

part 'update_task_result.g.dart';

@freezed
abstract class UpdateTaskResult extends BaseModel with _$UpdateTaskResult {
  UpdateTaskResult._();

  @JsonSerializable(explicitToJson: true)
  factory UpdateTaskResult({
    @Default(0) int insertedCount,
    @Default(0) int matchedCount,
    @Default(0) int modifiedCount,
    @Default(0) int upsertedCount,
    @Default(0) int deletedCount,
    @Default({}) Map<String, dynamic> upsertedIds,
    @Default({}) Map<String, dynamic> insertedIds,
  }) = _UpdateTaskResult;

  factory UpdateTaskResult.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskResultFromJson(json);
}
