import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_logger/core/enums/response_type.dart';
import 'package:task_logger/data/database/dao/task_dao/task_dao.dart';
import 'package:task_logger/data/repositories/task_repository_impl.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/domain/models/delete_task_result/delete_task_result.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/models/update_task_result/update_task_result.dart';
import 'package:task_logger/domain/repositories/task_repository.dart';
import 'package:task_logger/domain/usecases/params/create_tasks_params/create_tasks_params.dart';
import 'package:task_logger/domain/usecases/params/delete_tasks_params/delete_tasks_params.dart';
import 'package:task_logger/domain/usecases/params/get_tasks_params/get_tasks_params.dart';
import 'package:task_logger/domain/usecases/params/update_tasks_params/update_tasks_params.dart';

import '../../fixtures/fixture_reader.dart';
import 'task_repository_test.mocks.dart';

@GenerateMocks([TaskService])
@GenerateNiceMocks([MockSpec<TaskDao>()])
void main() {
  late TaskRepository taskRepository;
  late MockTaskService mockTaskService;
  late MockTaskDao mockTaskDao;

  setUp(() {
    mockTaskService = MockTaskService();
    mockTaskDao = MockTaskDao();
    taskRepository = TaskRepositoryImpl(mockTaskService, mockTaskDao);
  });

  group('TaskRepository Test', () {
    test('[GetTask] should get tasks', () async {
      final response = deserializeGetTasksResponse(
          jsonDecode(Fixtures.getTaskResponse) as Map<String, dynamic>);
      when(mockTaskService.getTasks(any)).thenAnswer((_) async => response);

      final res = await taskRepository.getTasks(const GetTasksParams(
        title: 'Task 1 offline update6',
      ));

      expect(res, isA<ResultSuccess<List<Task>>>());
      expect((res as ResultSuccess<List<Task>>).data, isNotEmpty);
      verify(mockTaskService.getTasks(any)).called(1);
      verifyNoMoreInteractions(mockTaskService);
    });

    test('[GetTask] should handle error when getting tasks fails', () async {
      when(mockTaskService.getTasks(any))
          .thenThrow(Exception('Failed to get tasks'));

      final res = await taskRepository.getTasks(const GetTasksParams(
        title: 'Task 1 offline update6',
      ));

      expect(res, isA<ResultError<List<Task>>>());
      expect((res as ResultError<List<Task>>).exception, isNotNull);
      verify(mockTaskService.getTasks(any)).called(1);
      verifyNoMoreInteractions(mockTaskService);
    });

    test('[CreateTask] should create task successfully', () async {
      final response = deserializeCreateTasksResponse(
          jsonDecode(Fixtures.createTaskResponse) as Map<String, dynamic>);
      when(mockTaskService.createTask(any)).thenAnswer((_) async => response);
      when(mockTaskDao.insertTasks(any)).thenAnswer((_) async => true);

      final res = await taskRepository.createTasks(CreateTasksParams(
        title: 'New Task',
        description: 'Task Description',
        dateTime: DateTime.parse('2024-05-02T10:00:00Z'),
        completed: false,
      ));

      expect(res, isA<ResultSuccess<BaseResponse<List<Task>>>>());
      expect((res as ResultSuccess<BaseResponse<List<Task>>>).data.type,
          equals(ResponseType.success));
      verify(mockTaskService.createTask(any)).called(1);
      verifyNoMoreInteractions(mockTaskService);
    });

    test('[CreateTask] should create locally if remote create fails', () async {
      when(mockTaskService.createTask(any))
          .thenThrow(Exception('Failed to create task'));
      when(mockTaskDao.insertTasks(any)).thenAnswer((_) async => true);

      final res = await taskRepository.createTasks(CreateTasksParams(
        title: 'New Task',
        description: 'Task Description',
        dateTime: DateTime.parse('2024-05-02T10:00:00Z'),
        completed: false,
      ));

      expect(res, isA<ResultError<BaseResponse<List<Task>>>>());
      verify(mockTaskService.createTask(any)).called(1);
      verify(mockTaskDao.insertTasks(any)).called(1);
    });

    test('[UpdateTask] should update task successfully', () async {
      final response = deserializeUpdateTasksResponse(
          jsonDecode(Fixtures.updateTaskResponse) as Map<String, dynamic>);
      when(mockTaskService.updateTasks(any)).thenAnswer((_) async => response);
      when(mockTaskDao.getTasks(any)).thenAnswer((_) async => [
            Task(
              id: '123',
              title: 'Old Task',
              description: 'Old Description',
              dateTime: DateTime.parse('2024-05-01T10:00:00Z'),
              completed: false,
              createdAt: DateTime.parse('2024-05-01T10:00:00Z'),
              updatedAt: DateTime.parse('2024-05-01T10:00:00Z'),
            )
          ]);
      when(mockTaskDao.updateTasks(any)).thenAnswer((_) async => true);

      final res = await taskRepository.updateTasks(UpdateTasksParams(
        id: '123',
        title: 'Updated Task',
        description: 'Updated Description',
        dateTime: DateTime.parse('2024-05-02T10:00:00Z'),
        completed: true,
      ));

      expect(res, isA<ResultSuccess<BaseResponse<UpdateTaskResult>>>());
      expect((res as ResultSuccess<BaseResponse<UpdateTaskResult>>).data.type,
          equals(ResponseType.success));
      expect(res.data.data?.matchedCount, equals(1));
      expect(res.data.data?.modifiedCount, equals(1));
      verify(mockTaskService.updateTasks(any)).called(1);
      verify(mockTaskDao.getTasks(any)).called(1);
      verifyNever(mockTaskDao.updateTasks(any));
      verifyNoMoreInteractions(mockTaskDao);
    });

    test('[DeleteTask] should delete task successfully', () async {
      final response = deserializeDeleteResponse(
          jsonDecode(Fixtures.deleteTaskResponse) as Map<String, dynamic>);
      when(mockTaskService.deleteTasks(any)).thenAnswer((_) async => response);
      when(mockTaskDao.deleteTasks(any)).thenAnswer((_) async => true);

      final res = await taskRepository.deleteTasks(const DeleteTasksParams(
        ids: ['123'],
      ));

      expect(res, isA<ResultSuccess<BaseResponse<DeleteTaskResult>>>());
      expect((res as ResultSuccess<BaseResponse<DeleteTaskResult>>).data.type,
          equals(ResponseType.success));
      expect(res.data.data?.deletedCount, equals(1));
      verify(mockTaskService.deleteTasks(any)).called(1);
      verify(mockTaskDao.deleteTasks(any)).called(1);
    });

    test('[DeleteTask] should delete locally if remote delete fails', () async {
      when(mockTaskService.deleteTasks(any))
          .thenThrow(Exception('Failed to delete task'));
      when(mockTaskDao.softDeleteTasks(any)).thenAnswer((_) async => true);

      final res = await taskRepository.deleteTasks(const DeleteTasksParams(
        ids: ['123'],
      ));

      expect(res, isA<ResultSuccess<BaseResponse<DeleteTaskResult>>>());
      expect((res as ResultSuccess<BaseResponse<DeleteTaskResult>>).data.type,
          equals(ResponseType.success));
      verify(mockTaskService.deleteTasks(any)).called(1);
      verify(mockTaskDao.softDeleteTasks(any)).called(1);
    });
  });
}
