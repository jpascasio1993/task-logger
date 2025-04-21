// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/core/enums/response_type.dart';

part 'base_response.freezed.dart';

part 'base_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class BaseResponse<T> with _$BaseResponse<T> {
  @JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
  const factory BaseResponse({
    T? data,
    required ResponseType type,
    @Default('') String title,
    @Default('') String message,
  }) = _BaseResponse<T>;

  factory BaseResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$BaseResponseFromJson(json, fromJsonT);
}
