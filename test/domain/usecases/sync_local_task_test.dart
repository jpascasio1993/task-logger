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
import 'package:task_logger/domain/usecases/task/sync_local_tasks.dart';

import '../../fixtures/fixture_reader.dart';
import 'sync_local_task_test.mocks.dart';

@GenerateMocks([TaskRepository, GetTasks])
void main() {
  late MockTaskRepository taskRepository;
  late SyncLocalTasks syncLocalTasks;
  late MockGetTasks getTasks;
  late BaseResponse<List<Task>> baseResponse;
  setUp(() {
    taskRepository = MockTaskRepository();
    getTasks = MockGetTasks();
    syncLocalTasks = SyncLocalTasks(taskRepository, getTasks);
    baseResponse = deserializeGetTasksResponse(
        jsonDecode(Fixtures.getTaskResponse) as Map<String, dynamic>);
    provideDummy<Result<List<Task>>>(Result.success(baseResponse.data!));
    provideDummy<Result<bool>>(const Result.success(true));
  });

  group('SyncLocalTasks usecase', () {
    test('should sync local tasks successfully', () async {
      const params = GetTasksParams();
      when(getTasks(params)).thenAnswer((_) async => const Result.success([]));
      when(taskRepository.syncLocalTasks(any))
          .thenAnswer((_) async => const Result.success(true));

      final result = await syncLocalTasks(params);

      expect(result, isA<ResultSuccess<bool>>());
      expect((result as ResultSuccess<bool>).data, equals(true));
      verify(getTasks(params)).called(1);
      verify(taskRepository.syncLocalTasks(any)).called(1);
      verifyNoMoreInteractions(taskRepository);
      verifyNoMoreInteractions(getTasks);
    });

    test('should handle sync failure from getTasks', () async {
      const params = GetTasksParams();
      const errorMessage = 'Failed to get tasks';
      when(getTasks(params)).thenAnswer((_) async =>
          Result.error(errorMessage, exception: Exception(errorMessage)));

      final result = await syncLocalTasks(params);

      expect(result, isA<ResultError<bool>>());
      final errorResult = result as ResultError<bool>;
      expect(errorResult.message, equals(errorMessage));
      verify(getTasks(params)).called(1);
      verifyNoMoreInteractions(getTasks);
      verifyZeroInteractions(taskRepository);
    });

    test('should handle sync failure from syncLocalTasks', () async {
      const params = GetTasksParams();
      const errorMessage = 'Failed to sync tasks';
      when(getTasks(params)).thenAnswer((_) async => const Result.success([]));
      when(taskRepository.syncLocalTasks(any)).thenAnswer((_) async =>
          Result.error(errorMessage, exception: Exception(errorMessage)));

      final result = await syncLocalTasks(params);

      expect(result, isA<ResultError<bool>>());
      final errorResult = result as ResultError<bool>;
      expect(errorResult.message, equals(errorMessage));
      verify(getTasks(params)).called(1);
      verify(taskRepository.syncLocalTasks(any)).called(1);
      verifyNoMoreInteractions(getTasks);
      verifyNoMoreInteractions(taskRepository);
    });

    test('should handle sync failure with empty error message', () async {
      const params = GetTasksParams();
      when(getTasks(params)).thenAnswer((_) async => const Result.success([]));
      when(taskRepository.syncLocalTasks(any))
          .thenAnswer((_) async => Result.error('', exception: Exception('')));

      final result = await syncLocalTasks(params);

      expect(result, isA<ResultError<bool>>());
      final errorResult = result as ResultError<bool>;
      expect(errorResult.message, isEmpty);
    });
  });
}
