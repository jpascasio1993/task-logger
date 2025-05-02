// ignore_for_file: inference_failure_on_instance_creation, document_ignores

import 'package:dio/dio.dart' hide ResponseType;
import 'package:objectid/objectid.dart';
import 'package:task_logger/core/enums/response_type.dart';
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

      if (res.type == ResponseType.success) {
        await _taskDao.deleteTasks(params.ids);
      }

      return Result.success(res);
    } on Exception catch (e, s) {
      final errorMessage = e is DioException ? e.message : e.toString();
      final stackTrace = e is DioException ? e.stackTrace : s;

      final successfullyDeleted = await _taskDao.softDeleteTasks(params.ids);
      if (!successfullyDeleted) {
        return Result.error(errorMessage, exception: e, stackTrace: stackTrace);
      }
      return Result.success(BaseResponse(
        data: DeleteTaskResult(
            acknowledged: successfullyDeleted, deletedCount: params.ids.length),
        type: ResponseType.success,
        title: 'Task deleted',
        message: 'Task deleted successfully',
      ));
    }
  }

  @override
  Future<Result<BaseResponse<List<Task>>>> createTasks(
      CreateTasksParams params) async {
    final task = [
      TaskDTO(
        title: params.title,
        description: params.description,
        dateTime: params.dateTime,
        completed: params.completed,
      ),
    ];
    try {
      final res = await _taskService.createTask(CreateTasksRequest(
        task,
      ));
      return Result.success(res);
    } on Exception catch (e, s) {
      final errorMessage = e is DioException ? e.message : e.toString();
      final stackTrace = e is DioException ? e.stackTrace : s;
      final id = ObjectId().hexString;
      final copyTask =
          task.map((e) => e.copyWith(id: id)).toList(growable: false);
      final added = await _taskDao.insertTasks(copyTask);

      if (!added) {
        return Result.error(errorMessage, exception: e, stackTrace: stackTrace);
      }

      final tasks = await _taskDao.getTasks([id]);

      if (tasks.isEmpty) {
        return Result.error(errorMessage, exception: e, stackTrace: stackTrace);
      }

      return Result.success(BaseResponse(
        data: tasks,
        type: ResponseType.success,
        title: 'Task created',
        message: 'Task created successfully',
      ));
    }
  }

  @override
  Future<Result<BaseResponse<UpdateTaskResult>>> updateTasks(
      UpdateTasksParams params) async {
    try {
      final taskResult = await _taskDao.getTasks([params.id]);
      final updatedTask = taskResult
          .map((e) => TaskDTO(
                id: e.id,
                title: params.title,
                description: params.description,
                dateTime: params.dateTime,
                completed: params.completed,
                createdAt: e.createdAt,
                updatedAt: e.updatedAt,
              ))
          .toList(growable: false);
      final res = await _taskService
          .updateTasks(UpdateTasksRequest(tasks: updatedTask));
      return Result.success(res);
    } on Exception catch (e, s) {
      final task = [
        TaskDTO(
          id: params.id,
          title: params.title,
          description: params.description,
          dateTime: params.dateTime,
          completed: params.completed,
        ),
      ];

      final errorMessage = e is DioException ? e.message : e.toString();
      final stackTrace = e is DioException ? e.stackTrace : s;

      final sucessfullyUpdated = await _taskDao.updateTasks(task);
      if (!sucessfullyUpdated) {
        return Result.error(errorMessage, exception: e, stackTrace: stackTrace);
      }

      return Result.success(BaseResponse(
        data: UpdateTaskResult(upsertedCount: task.length),
        type: ResponseType.success,
        title: 'Task updated',
        message: 'Task updated successfully',
      ));
    }
  }

  @override
  Stream<List<Task>> watchTasks() => _taskDao.watchTasks().handleError(
      (Object error, StackTrace stackTrace) => Result.error(error.toString(),
          exception: BaseException(
              error.toString(), error is Exception ? error : Exception(error)),
          stackTrace: stackTrace));

  @override
  Future<Result<bool>> syncLocalTasks(List<Task> tasks) async {
    final res = await _taskDao.insertTasks(tasks
        .map((e) => TaskDTO(
            completed: e.completed,
            id: e.id,
            updatedAt: e.updatedAt,
            createdAt: e.createdAt,
            dateTime: e.dateTime,
            description: e.description,
            title: e.title,
            isUploaded: true))
        .toList(growable: false));
    return Result.success(res);
  }

  @override
  Future<Result<BaseResponse<List<Task>>>> syncLocallyCreatedTasks() async {
    final tasks = await _taskDao.getLocallyCreatedTasks();
    if (tasks.isEmpty) {
      return const Result.success(BaseResponse(
        data: [],
        type: ResponseType.success,
      ));
    }
    try {
      final res = await _taskService.createTask(CreateTasksRequest(
        tasks,
      ));
      if (res.type == ResponseType.success) {
        await _taskDao.updateTasks(tasks
            .map((e) => e.copyWith(isUploaded: true))
            .toList(growable: false));
      }
      return Result.success(res);
    } on DioException catch (e) {
      return Result.error(e.message, exception: e, stackTrace: e.stackTrace);
    } on Exception catch (e, s) {
      return Result.error(null, exception: e, stackTrace: s);
    }
  }

  @override
  Future<Result<BaseResponse<DeleteTaskResult>>>
      syncLocallyDeletedTasks() async {
    final tasks = await _taskDao.getSoftDeletedTasks();
    if (tasks.isEmpty) {
      return Result.success(BaseResponse(
        data: DeleteTaskResult(acknowledged: true, deletedCount: 0),
        type: ResponseType.success,
      ));
    }

    try {
      final res = await _taskService.deleteTasks(DeleteTasksRequest(
        ids: tasks.map((e) => e.id!).toList(),
      ));
      if (res.type == ResponseType.success) {
        await _taskDao.updateTasks(tasks
            .map((e) => e.copyWith(isUploaded: true))
            .toList(growable: false));
      }
      return Result.success(res);
    } on DioException catch (e) {
      return Result.error(e.message, exception: e, stackTrace: e.stackTrace);
    } on Exception catch (e, s) {
      return Result.error(null, exception: e, stackTrace: s);
    }
  }

  @override
  Future<Result<BaseResponse<UpdateTaskResult>>>
      syncLocallyUpdatedTasks() async {
    final tasks = await _taskDao.getLocallyUpdatedTasks();
    if (tasks.isEmpty) {
      return Result.success(BaseResponse(
        data: UpdateTaskResult(),
        type: ResponseType.success,
      ));
    }
    try {
      final res = await _taskService.updateTasks(UpdateTasksRequest(
        tasks: tasks,
      ));
      if (res.type == ResponseType.success) {
        await _taskDao.updateTasks(tasks
            .map((e) => e.copyWith(isUploaded: true))
            .toList(growable: false));
        await _taskDao.deleteUpdatedTasks(
            tasks.map((e) => e.id!).toList(growable: false));
      }
      return Result.success(res);
    } on DioException catch (e) {
      return Result.error(e.message, exception: e, stackTrace: e.stackTrace);
    } on Exception catch (e, s) {
      return Result.error(null, exception: e, stackTrace: s);
    }
  }
}
