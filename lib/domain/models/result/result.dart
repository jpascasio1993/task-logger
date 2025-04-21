import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = ResultSuccess;

  const factory Result.error(String? message,
      {required Exception exception, StackTrace? stackTrace}) = ResultError;

  @override
  String toString() {
    return switch (this) {
      ResultSuccess<T>(:final data) => 'Success[data=$data]',
      ResultError<T>(:final exception) => 'Error[exception=$exception]',
    };
  }
}
