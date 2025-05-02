import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/domain/models/delete_task_result/delete_task_result.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/models/update_task_result/update_task_result.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/task/sync_remote_tasks.dart';

import '../../fixtures/fixture_reader.dart';
import 'sync_remote_task_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late MockTaskRepository taskRepository;
  late SyncRemoteTasks syncRemoteTasks;
  late BaseResponse<List<Task>> createdTasksResponse;
  late BaseResponse<DeleteTaskResult> deletedTasksResponse;
  late BaseResponse<UpdateTaskResult> updatedTasksResponse;

  setUp(() {
    taskRepository = MockTaskRepository();
    syncRemoteTasks = SyncRemoteTasks(taskRepository);
    createdTasksResponse = deserializeCreateTasksResponse(
        jsonDecode(Fixtures.createTaskResponse) as Map<String, dynamic>);
    deletedTasksResponse = deserializeDeleteResponse(
        jsonDecode(Fixtures.deleteTaskResponse) as Map<String, dynamic>);
    updatedTasksResponse = deserializeUpdateTasksResponse(
        jsonDecode(Fixtures.updateTaskResponse) as Map<String, dynamic>);
    provideDummy<Result<BaseResponse<List<Task>>>>(
        Result.success(createdTasksResponse));
    provideDummy<Result<BaseResponse<DeleteTaskResult>>>(
        Result.success(deletedTasksResponse));
    provideDummy<Result<BaseResponse<UpdateTaskResult>>>(
        Result.success(updatedTasksResponse));
  });

  group('SyncRemoteTasks usecase', () {
    test('should sync all tasks successfully', () async {
      when(taskRepository.syncLocallyCreatedTasks())
          .thenAnswer((_) async => Result.success(createdTasksResponse));
      when(taskRepository.syncLocallyDeletedTasks())
          .thenAnswer((_) async => Result.success(deletedTasksResponse));
      when(taskRepository.syncLocallyUpdatedTasks())
          .thenAnswer((_) async => Result.success(updatedTasksResponse));

      final result = await syncRemoteTasks();

      expect(result, isA<ResultSuccess<bool>>());
      expect((result as ResultSuccess<bool>).data, equals(true));
      verify(taskRepository.syncLocallyCreatedTasks()).called(1);
      verify(taskRepository.syncLocallyDeletedTasks()).called(1);
      verify(taskRepository.syncLocallyUpdatedTasks()).called(1);
      verifyNoMoreInteractions(taskRepository);
    });

    test('should handle failure in syncing created tasks', () async {
      const errorMessage = 'Failed to sync created tasks';
      when(taskRepository.syncLocallyCreatedTasks()).thenAnswer((_) async =>
          Result.error(errorMessage, exception: Exception(errorMessage)));
      when(taskRepository.syncLocallyDeletedTasks())
          .thenAnswer((_) async => Result.success(deletedTasksResponse));
      when(taskRepository.syncLocallyUpdatedTasks())
          .thenAnswer((_) async => Result.success(updatedTasksResponse));

      final result = await syncRemoteTasks();

      expect(result, isA<ResultSuccess<bool>>());
      expect((result as ResultSuccess<bool>).data, equals(true));
      verify(taskRepository.syncLocallyCreatedTasks()).called(1);
      verify(taskRepository.syncLocallyDeletedTasks()).called(1);
      verify(taskRepository.syncLocallyUpdatedTasks()).called(1);
      verifyNoMoreInteractions(taskRepository);
    });

    test('should handle failure in syncing deleted tasks', () async {
      const errorMessage = 'Failed to sync deleted tasks';
      when(taskRepository.syncLocallyCreatedTasks())
          .thenAnswer((_) async => Result.success(createdTasksResponse));
      when(taskRepository.syncLocallyDeletedTasks()).thenAnswer((_) async =>
          Result.error(errorMessage, exception: Exception(errorMessage)));
      when(taskRepository.syncLocallyUpdatedTasks())
          .thenAnswer((_) async => Result.success(updatedTasksResponse));

      final result = await syncRemoteTasks();

      expect(result, isA<ResultSuccess<bool>>());
      expect((result as ResultSuccess<bool>).data, equals(true));
      verify(taskRepository.syncLocallyCreatedTasks()).called(1);
      verify(taskRepository.syncLocallyDeletedTasks()).called(1);
      verify(taskRepository.syncLocallyUpdatedTasks()).called(1);
      verifyNoMoreInteractions(taskRepository);
    });

    test('should handle failure in syncing updated tasks', () async {
      const errorMessage = 'Failed to sync updated tasks';
      when(taskRepository.syncLocallyCreatedTasks())
          .thenAnswer((_) async => Result.success(createdTasksResponse));
      when(taskRepository.syncLocallyDeletedTasks())
          .thenAnswer((_) async => Result.success(deletedTasksResponse));
      when(taskRepository.syncLocallyUpdatedTasks()).thenAnswer((_) async =>
          Result.error(errorMessage, exception: Exception(errorMessage)));

      final result = await syncRemoteTasks();

      expect(result, isA<ResultSuccess<bool>>());
      expect((result as ResultSuccess<bool>).data, equals(true));
      verify(taskRepository.syncLocallyCreatedTasks()).called(1);
      verify(taskRepository.syncLocallyDeletedTasks()).called(1);
      verify(taskRepository.syncLocallyUpdatedTasks()).called(1);
      verifyNoMoreInteractions(taskRepository);
    });
  });
}
