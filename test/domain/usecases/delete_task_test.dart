import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/domain/models/delete_task_result/delete_task_result.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/delete_tasks_params/delete_tasks_params.dart';
import 'package:task_logger/domain/usecases/task/delete_tasks.dart';

import '../../fixtures/fixture_reader.dart';
import 'delete_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository taskRepository;
  late DeleteTasks deleteTasks;
  late BaseResponse<DeleteTaskResult> baseResponse;

  setUp(() {
    taskRepository = MockTaskRepository();
    deleteTasks = DeleteTasks(taskRepository);
    baseResponse = deserializeDeleteResponse(
        jsonDecode(Fixtures.deleteTaskResponse) as Map<String, dynamic>);
    provideDummy<Result<BaseResponse<DeleteTaskResult>>>(
        Result.success(baseResponse));
  });

  group('DeleteTasks usecase', () {
    test('should delete tasks successfully', () async {
      when(taskRepository.deleteTasks(any))
          .thenAnswer((_) async => Result.success(baseResponse));

      final result =
          await deleteTasks(const DeleteTasksParams(ids: ['task_id']));

      expect(result, isA<ResultSuccess<BaseResponse<DeleteTaskResult>>>());

      final successResult =
          result as ResultSuccess<BaseResponse<DeleteTaskResult>>;
      expect(successResult.data.data?.acknowledged, equals(true));
      expect(successResult.data.data?.deletedCount, equals(1));
      expect(successResult.data.message, equals('Tasks deleted successfully'));
      verify(taskRepository.deleteTasks(any)).called(1);
    });

    test('should handle task deletion failure', () async {
      const errorMessage = 'Failed to delete tasks';
      when(taskRepository.deleteTasks(any)).thenAnswer((_) async =>
          Result.error(errorMessage, exception: Exception(errorMessage)));

      final result =
          await deleteTasks(const DeleteTasksParams(ids: ['task_id']));

      expect(result, isA<ResultError<BaseResponse<DeleteTaskResult>>>());
      final errorResult = result as ResultError<BaseResponse<DeleteTaskResult>>;
      expect(errorResult.message, equals(errorMessage));
    });

    test('should handle task deletion failure with empty error message',
        () async {
      when(taskRepository.deleteTasks(any))
          .thenAnswer((_) async => Result.error('', exception: Exception('')));

      final result =
          await deleteTasks(const DeleteTasksParams(ids: ['task_id']));

      expect(result, isA<ResultError<BaseResponse<DeleteTaskResult>>>());
      final errorResult = result as ResultError<BaseResponse<DeleteTaskResult>>;
      expect(errorResult.message,
          equals('Failed to delete tasks. Try again later'));
    });
  });
}
