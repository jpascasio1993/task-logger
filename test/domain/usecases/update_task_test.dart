import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/update_task_result/update_task_result.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/update_tasks_params/update_tasks_params.dart';
import 'package:task_logger/domain/usecases/task/update_tasks.dart';

import '../../fixtures/fixture_reader.dart';
import 'update_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository taskRepository;
  late UpdateTasks updateTasks;
  late BaseResponse<UpdateTaskResult> baseResponse;
  setUp(() {
    taskRepository = MockTaskRepository();
    updateTasks = UpdateTasks(taskRepository);
    baseResponse = deserializeUpdateTasksResponse(
        jsonDecode(Fixtures.updateTaskResponse) as Map<String, dynamic>);
    provideDummy<Result<BaseResponse<UpdateTaskResult>>>(
        Result.success(baseResponse));
  });

  group('UpdateTasks usecase', () {
    test('should update tasks successfully', () async {
      when(taskRepository.updateTasks(any))
          .thenAnswer((_) async => Result.success(baseResponse));

      final result = await updateTasks(const UpdateTasksParams(
        id: '1',
        title: 'Updated Task',
        description: 'Updated Description',
        completed: true,
      ));

      expect(result, isA<ResultSuccess<BaseResponse<UpdateTaskResult>>>());
      final successResult =
          result as ResultSuccess<BaseResponse<UpdateTaskResult>>;
      expect(successResult.data.data?.modifiedCount, equals(1));
      expect(successResult.data.data?.matchedCount, equals(1));
      expect(successResult.data.message, equals('Tasks updated successfully'));
    });

    test('should handle task update failure', () async {
      const errorMessage = 'Failed to update tasks';
      when(taskRepository.updateTasks(any)).thenAnswer((_) async =>
          Result.error(errorMessage, exception: Exception(errorMessage)));

      final result = await updateTasks(const UpdateTasksParams(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        completed: false,
      ));

      expect(result, isA<ResultError<BaseResponse<UpdateTaskResult>>>());
      final errorResult = result as ResultError<BaseResponse<UpdateTaskResult>>;
      expect(errorResult.message, equals(errorMessage));
    });

    test('should handle task update failure with empty error message',
        () async {
      when(taskRepository.updateTasks(any))
          .thenAnswer((_) async => Result.error('', exception: Exception('')));

      final result = await updateTasks(const UpdateTasksParams(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        completed: false,
      ));

      expect(result, isA<ResultError<BaseResponse<UpdateTaskResult>>>());
      final errorResult = result as ResultError<BaseResponse<UpdateTaskResult>>;
      expect(errorResult.message,
          equals('Failed to update tasks. Try again later'));
    });
  });
}
