// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:task_logger/data/dto/task_dto/task_dto.dart';
import 'package:task_logger/data/request/create_tasks_request/create_tasks_request.dart';
import 'package:task_logger/data/request/delete_tasks_request/delete_tasks_request.dart';
import 'package:task_logger/data/request/get_tasks_request/get_tasks_request.dart';
import 'package:task_logger/data/request/update_tasks_request/update_tasks_request.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/data/services/task_service/task_service.dart';
import 'package:task_logger/domain/models/delete_task_result/delete_task_result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/models/update_task_result/update_task_result.dart';
import '../../fixtures/fixture_reader.dart';
import 'service_test_util.dart';

void main() {
  late ServiceTestUtil serviceTestUtil;
  late TaskService taskService;
  late TaskServiceAPI taskServiceAPI;
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    serviceTestUtil = ServiceTestUtil();
    dio = serviceTestUtil.getDio();
    dioAdapter = serviceTestUtil.getDioAdapter(dio);
    taskServiceAPI = TaskServiceAPI(dio);
    taskService = TaskService(taskServiceAPI);
  });

  group('TaskService test', () {
    test('createTask should successfully create tasks', () async {
      final json =
          jsonDecode(Fixtures.createTaskResponse) as Map<String, dynamic>;
      final createTaskResponse = deserializeCreateTasksResponse(json);

      final task = createTaskResponse.data!.first;

      dioAdapter.onPost(
        '/task_logger/tasks',
        (server) => server.reply(200, json),
      );

      final res = await taskService.createTask(CreateTasksRequest([
        TaskDTO(
            title: task.title,
            description: task.description,
            dateTime: task.dateTime,
            completed: task.completed,
            id: task.id)
      ]));
      expect(res, isA<BaseResponse<List<Task>>>());
      expect(res.data, isNotEmpty);
      expect(res.data?.first.id, task.id);
    });

    test('getTasks should successfully fetch tasks', () async {
      final json = jsonDecode(Fixtures.getTaskResponse) as Map<String, dynamic>;
      final getTaskResponse = deserializeGetTasksResponse(json);
      final task = getTaskResponse.data!.first;

      dioAdapter.onGet(
        '/task_logger/tasks',
        (server) => server.reply(200, json),
      );

      final res = await taskService.getTasks(GetTasksRequest(id: null));
      expect(res, isA<BaseResponse<List<Task>>>());
      expect(res.data, isNotEmpty);
      expect(res.data?.first.id, task.id);
    });

    test('updateTasks should successfully update tasks', () async {
      final json =
          jsonDecode(Fixtures.updateTaskResponse) as Map<String, dynamic>;

      dioAdapter.onPut(
        '/task_logger/tasks',
        (server) => server.reply(200, json),
      );

      final res = await taskService.updateTasks(UpdateTasksRequest(tasks: [
        TaskDTO(
            title: 'sample',
            description: 'sample',
            completed: true,
            id: '68138e86a89ff83fad433a6e')
      ]));
      expect(res, isA<BaseResponse<UpdateTaskResult>>());
      expect(res.data?.modifiedCount, 1);
    });

    test('deleteTasks should successfully delete tasks', () async {
      final json =
          jsonDecode(Fixtures.deleteTaskResponse) as Map<String, dynamic>;

      dioAdapter.onDelete(
        '/task_logger/tasks',
        (server) => server.reply(200, json),
      );

      final res = await taskService
          .deleteTasks(DeleteTasksRequest(ids: ['68138e86a89ff83fad433a6e']));
      expect(res, isA<BaseResponse<DeleteTaskResult>>());
      expect(res.data?.deletedCount, 1);
    });

    test('createTask should fail and return DioException', () async {
      dioAdapter.onPost(
        '/task_logger/tasks',
        (server) => server.reply(400, {'message': 'Bad Request'}),
      );

      expect(
        taskService.createTask(CreateTasksRequest([])),
        throwsA(isA<DioException>()),
      );
    });

    test('getTasks should fail and return DioException', () async {
      dioAdapter.onGet(
        '/task_logger/tasks',
        (server) => server.reply(404, {'message': 'Not Found'}),
      );
// server.throws(404, DioException(requestOptions: RequestOptions(path: '/task_logger/tasks'), type: DioExceptionType.badResponse))
      expect(
        taskService.getTasks(GetTasksRequest(id: null)),
        throwsA(isA<DioException>()),
      );
    });

    test('updateTasks should fail and return DioException', () async {
      dioAdapter.onPut(
        '/task_logger/tasks',
        (server) => server.reply(400, {'message': 'Bad Request'}),
      );

      expect(
        taskService.updateTasks(UpdateTasksRequest(tasks: [])),
        throwsA(isA<DioException>()),
      );
    });

    test('deleteTasks should fail and return DioException', () async {
      dioAdapter.onDelete(
        '/task_logger/tasks',
        (server) => server.reply(404, {'message': 'Not Found'}),
      );

      expect(
        taskService.deleteTasks(DeleteTasksRequest(ids: [])),
        throwsA(isA<DioException>()),
      );
    });
  });
}
