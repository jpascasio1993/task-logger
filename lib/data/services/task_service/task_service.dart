import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:task_logger/core/utils/isolate.dart';
import 'package:task_logger/data/request/create_tasks_request/create_tasks_request.dart';
import 'package:task_logger/data/request/delete_tasks_request/delete_tasks_request.dart';
import 'package:task_logger/data/request/get_tasks_request/get_tasks_request.dart';
import 'package:task_logger/data/request/update_tasks_request/update_tasks_request.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/domain/models/delete_task_result/delete_task_result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/models/update_task_result/update_task_result.dart';

part 'task_service.g.dart';

class TaskService {
  TaskService(this.taskServiceAPI);

  final TaskServiceAPI taskServiceAPI;

  Future<BaseResponse<List<Task>>> getTasks(GetTasksRequest request) async {
    final result = await taskServiceAPI.getTasks(request);
    final response = result.data as Map<String, dynamic>;
    final res = await compute(deserializeGetTasksResponse, response);
    return res;
  }

  Future<BaseResponse<DeleteTaskResult>> deleteTasks(
      DeleteTasksRequest request) async {
    final result = await taskServiceAPI.deleteTasks(request);
    final response = result.data as Map<String, dynamic>;
    final res = await compute(deserializeDeleteResponse, response);
    return res;
  }

  Future<BaseResponse<List<Task>>> createTask(
      CreateTasksRequest request) async {
    final result = await taskServiceAPI.createTask(request);
    final response = result.data as Map<String, dynamic>;
    final res = await compute(deserializeCreateTasksResponse, response);
    return res;
  }

  Future<BaseResponse<UpdateTaskResult>> updateTasks(
      UpdateTasksRequest request) async {
    final result = await taskServiceAPI.updateTasks(request);
    final response = result.data as Map<String, dynamic>;
    final res = await compute(deserializeUpdateTasksResponse, response);
    return res;
  }
}

@RestApi(
  parser: Parser.FlutterCompute,
)
abstract class TaskServiceAPI {
  factory TaskServiceAPI(Dio dio) => _TaskServiceAPI(dio);

  @GET('/task_logger/tasks')
  Future<HttpResponse<dynamic>> getTasks(@Body() GetTasksRequest request);

  @DELETE('/task_logger/tasks')
  Future<HttpResponse<dynamic>> deleteTasks(@Body() DeleteTasksRequest request);

  @POST('/task_logger/tasks')
  Future<HttpResponse<dynamic>> createTask(@Body() CreateTasksRequest request);

  @PUT('/task_logger/tasks')
  Future<HttpResponse<dynamic>> updateTasks(@Body() UpdateTasksRequest request);
}

GetTasksRequest seriazlizeGetTaskRequest(Map<String, dynamic> json) =>
    GetTasksRequest.fromJson(json);

BaseResponse<List<Task>> deserializeGetTasksResponse(
        Map<String, dynamic> json) =>
    BaseResponse.fromJson(
        json,
        (json) =>
            (json as List<dynamic>?)
                ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
                .toList() ??
            []);

BaseResponse<DeleteTaskResult> deserializeDeleteResponse(
        Map<String, dynamic> json) =>
    BaseResponse.fromJson(json,
        (json) => DeleteTaskResult.fromJson(json! as Map<String, dynamic>));

BaseResponse<List<Task>> deserializeCreateTasksResponse(
        Map<String, dynamic> json) =>
    BaseResponse.fromJson(
        json,
        (json) =>
            (json as List<dynamic>?)
                ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
                .toList() ??
            []);

BaseResponse<UpdateTaskResult> deserializeUpdateTasksResponse(
        Map<String, dynamic> json) =>
    BaseResponse.fromJson(json,
        (json) => UpdateTaskResult.fromJson(json! as Map<String, dynamic>));
