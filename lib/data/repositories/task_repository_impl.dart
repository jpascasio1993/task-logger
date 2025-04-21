// ignore_for_file: inference_failure_on_instance_creation, document_ignores

import 'package:dio/dio.dart';
import 'package:task_logger/core/utils/dio/exceptions/base_exception.dart';
import 'package:task_logger/data/database/dao/task_dao/task_dao.dart';
import 'package:task_logger/data/dto/task_dto/task_dto.dart';
import 'package:task_logger/data/request/create_tasks_request/create_tasks_request.dart';
import 'package:task_logger/data/request/delete_tasks_request/delete_tasks_request.dart';
import 'package:task_logger/data/request/get_tasks_request/get_tasks_request.dart';
import 'package:task_logger/data/request/update_tasks_request/update_tasks_request.dart';
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

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._taskService, this._taskDao);

  final TaskService _taskService;
  final TaskDao _taskDao;

  @override
  Future<Result<List<Task>>> getTasks(GetTasksParams params) async {
    try {
      final res = await _taskService.getTasks(GetTasksRequest(
        id: params.id,
        title: params.title,
        description: params.description,
        dateTime: params.dateTime,
        completed: params.completed,
      ));
      return Result.success(res.data!);
    } on DioException catch (e) {
      return Result.error(e.message, exception: e, stackTrace: e.stackTrace);
    } on Exception catch (e, s) {
      return Result.error(null, exception: e, stackTrace: s);
    }
  }

  @override
  Future<Result<BaseResponse<DeleteTaskResult>>> deleteTasks(
      DeleteTasksParams params) async {
    try {
      final res = await _taskService.deleteTasks(DeleteTasksRequest(
        ids: params.ids,
      ));
      return Result.success(res);
    } on DioException catch (e) {
      return Result.error(e.message, exception: e, stackTrace: e.stackTrace);
    } on Exception catch (e, s) {
      return Result.error(null, exception: e, stackTrace: s);
    }
  }

  @override
  Future<Result<BaseResponse<List<Task>>>> createTasks(
      CreateTasksParams params) async {
    try {
      final res = await _taskService.createTask(CreateTasksRequest(
        [
          TaskDTO(
            title: params.title,
            description: params.description,
            dateTime: params.dateTime,
            completed: params.completed,
          ),
        ],
      ));
      return Result.success(res);
    } on DioException catch (e) {
      return Result.error(e.message, exception: e, stackTrace: e.stackTrace);
    } on Exception catch (e, s) {
      return Result.error(null, exception: e, stackTrace: s);
    }
  }

  @override
  Future<Result<BaseResponse<UpdateTaskResult>>> updateTasks(
      UpdateTasksParams params) async {
    try {
      final res = await _taskService.updateTasks(UpdateTasksRequest(
        [
          TaskDTO(
            id: params.id,
            title: params.title,
            description: params.description,
            dateTime: params.dateTime,
            completed: params.completed,
          ),
        ],
      ));
      return Result.success(res);
    } on DioException catch (e) {
      return Result.error(e.message, exception: e, stackTrace: e.stackTrace);
    } on Exception catch (e, s) {
      return Result.error(null, exception: e, stackTrace: s);
    }
  }

  @override
  Stream<List<Task>> watchTasks() => _taskDao.watchTasks().handleError(
      (Object error, StackTrace stackTrace) => Result.error(error.toString(),
          exception: BaseException(
              error.toString(), error is Exception ? error : Exception(error)),
          stackTrace: stackTrace));

  @override
  Future<Result<bool>> syncLocalTasks(List<TaskDTO> tasks) async {
    final res = await _taskDao.insertTasks(tasks);
    return Result.success(res);
  }
}
