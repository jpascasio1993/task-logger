import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/create_tasks_params/create_tasks_params.dart';
import 'package:task_logger/domain/usecases/task/create_tasks.dart';

import '../../fixtures/fixture_reader.dart';
import 'create_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository taskRepository;
  late CreateTasks createTasks;
  late BaseResponse<List<Task>> baseResponse;
  setUp(() {
    taskRepository = MockTaskRepository();
    createTasks = CreateTasks(taskRepository);
    baseResponse = deserializeCreateTasksResponse(
        jsonDecode(Fixtures.createTaskResponse) as Map<String, dynamic>);
    provideDummy<Result<BaseResponse<List<Task>>>>(
        Result.success(baseResponse));
  });

  group('CreateTasks usecase', () {
    test('should create tasks successfully', () async {
      when(taskRepository.createTasks(any))
          .thenAnswer((_) async => Result.success(baseResponse));

      final result = await createTasks(const CreateTasksParams(
        title: 'Test Task',
        description: 'Test Description',
        completed: false,
      ));

      expect(result, isA<ResultSuccess<BaseResponse<List<Task>>>>());
      verify(taskRepository.createTasks(any)).called(1);
      verifyNoMoreInteractions(taskRepository);
    });

    test('should verify created tasks data', () async {
      when(taskRepository.createTasks(any))
          .thenAnswer((_) async => Result.success(baseResponse));

      final result = await createTasks(const CreateTasksParams(
        title: 'Task 5',
        description: 'Test Description',
        completed: false,
      ));

      expect(result, isA<ResultSuccess<BaseResponse<List<Task>>>>());

      final successResult = result as ResultSuccess<BaseResponse<List<Task>>>;
      expect(successResult.data.data?.length, equals(2));
      expect(successResult.data.data?[0].title, equals('Task 5'));
      expect(successResult.data.message, equals('Tasks created successfully'));
    });

    test('should handle task creation failure', () async {
      const errorMessage = 'Failed to create tasks';
      when(taskRepository.createTasks(any)).thenAnswer((_) async =>
          Result.error(errorMessage, exception: Exception(errorMessage)));

      final result = await createTasks(const CreateTasksParams(
        title: 'Test Task',
        description: 'Test Description',
        completed: false,
      ));

      expect(result, isA<ResultError<BaseResponse<List<Task>>>>());
      final errorResult = result as ResultError<BaseResponse<List<Task>>>;
      expect(errorResult.message, equals(errorMessage));
    });

    test('should handle task creation failure with empty error message',
        () async {
      when(taskRepository.createTasks(any))
          .thenAnswer((_) async => Result.error('', exception: Exception('')));

      final result = await createTasks(const CreateTasksParams(
        title: 'Test Task',
        description: 'Test Description',
        completed: false,
      ));

      expect(result, isA<ResultError<BaseResponse<List<Task>>>>());
      final errorResult = result as ResultError<BaseResponse<List<Task>>>;
      expect(errorResult.message,
          equals('Failed to create tasks. Try again later'));
    });
  });
}
