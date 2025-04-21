// ignore_for_file: invalid_annotation_target, document_ignores

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/data/converters/json/date_time_converter.dart';
import 'package:task_logger/domain/models/base_model.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task extends BaseModel with _$Task {
  Task._();

  @JsonSerializable(explicitToJson: true)
  factory Task({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String description,
    @DateTimeConverter() required DateTime dateTime,
    @Default(false) bool completed,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
