import 'package:flutter/foundation.dart';

@immutable
class BaseException implements Exception {
  const BaseException(this.message, [this.exception, this.stackTrace]);

  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  @override
  String toString() => 'BaseException: $message \n\n'
      'originalException: $exception\n\n'
      'stackTrace: $stackTrace\n\n';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BaseException &&
        other.message == message &&
        ((other.exception == exception) ||
            (other.exception is Exception &&
                exception is Exception &&
                other.exception.toString() == exception.toString())) &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => Object.hash(message, exception, stackTrace);
}
