// ignore_for_file: inference_failure_on_function_return_type, avoid_positional_boolean_parameters, document_ignores

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_logger/core/utils/dio/exceptions/base_exception.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  Future<void> run(AsyncCallback task,
      {required Function(bool isLoading, BaseException? exception) onProcess,
      Function(bool isLoading, BaseException? exception)? onError}) async {
    try {
      onProcess(true, null);
      await task();
      onProcess(false, null);
    } catch (err, s) {
      final exception = switch (err) {
        final BaseException e => e,
        final Exception e => BaseException(
            e.toString().split(':').lastOrNull?.trim() ?? e.toString(), e, s),
        _ => BaseException(
            err.toString().split(':').lastOrNull?.trim() ?? err.toString()),
      };
      if (onError != null) {
        onError(false, exception);
      }
      addError(exception, s);
    }
  }

  @override
  void add(E event) {
    if (isClosed) return;
    super.add(event);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    if (isClosed) return;
    super.addError(error, stackTrace);
  }
}
