import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/data/converters/json/date_time_converter.dart';

part 'task_dto.freezed.dart';

part 'task_dto.g.dart';

@freezed
abstract class TaskDTO with _$TaskDTO {
  @JsonSerializable(explicitToJson: true)
  factory TaskDTO(
      {@JsonKey(name: '_id') String? id,
      required String title,
      required String description,
      bool? completed,
      @DateTimeConverter() DateTime? dateTime,
      @DateTimeConverter() DateTime? createdAt,
      @DateTimeConverter() DateTime? updatedAt,
      @JsonKey(includeToJson: true) bool? isUploaded,
      @JsonKey(includeToJson: true) bool? isDeleted}) = _TaskDTO;

  factory TaskDTO.fromJson(Map<String, dynamic> json) =>
      _$TaskDTOFromJson(json);
}
