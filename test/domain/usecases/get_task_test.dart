import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/get_tasks_params/get_tasks_params.dart';
import 'package:task_logger/domain/usecases/task/get_tasks.dart';

import '../../fixtures/fixture_reader.dart';
import 'get_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository taskRepository;
  late GetTasks getTasks;
  late BaseResponse<List<Task>> baseResponse;

  setUp(() {
    taskRepository = MockTaskRepository();
    getTasks = GetTasks(taskRepository);
    baseResponse = deserializeGetTasksResponse(
        jsonDecode(Fixtures.getTaskResponse) as Map<String, dynamic>);
    provideDummy<Result<List<Task>>>(Result.success(baseResponse.data!));
  });

  group('GetTasks usecase', () {
    test('should get tasks successfully', () async {
      when(taskRepository.getTasks(any))
          .thenAnswer((_) async => Result.success(baseResponse.data!));

      final result = await getTasks(const GetTasksParams(
        title: 'Task 1 offline update6',
      ));

      expect(result, isA<ResultSuccess<List<Task>>>());

      final successResult = result as ResultSuccess<List<Task>>;
      expect(successResult.data.length, equals(1));
      expect(successResult.data[0].title, equals('Task 1 offline update6'));
      verify(taskRepository.getTasks(any)).called(1);
      verifyNoMoreInteractions(taskRepository);
    });

    test('should handle task fetching failure', () async {
      const errorMessage = 'Failed to fetch tasks';
      when(taskRepository.getTasks(any)).thenAnswer((_) async =>
          Result.error(errorMessage, exception: Exception(errorMessage)));

      final result = await getTasks(const GetTasksParams(
        title: 'Task 1 offline update6',
      ));

      expect(result, isA<ResultError<List<Task>>>());
      final errorResult = result as ResultError<List<Task>>;
      expect(errorResult.message, equals(errorMessage));
    });

    test('should handle task fetching failure with empty error message',
        () async {
      when(taskRepository.getTasks(any))
          .thenAnswer((_) async => Result.error('', exception: Exception('')));

      final result = await getTasks(const GetTasksParams(
        title: 'Task 1 offline update6',
      ));

      expect(result, isA<ResultError<List<Task>>>());
      final errorResult = result as ResultError<List<Task>>;
      expect(errorResult.message,
          equals('Failed to retrieve tasks. Try again later'));
    });
  });
}
