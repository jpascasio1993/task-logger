import 'package:task_logger/data/dto/task_dto/task_dto.dart';
import 'package:task_logger/data/response/base_response/base_response.dart';
import 'package:task_logger/domain/models/delete_task_result/delete_task_result.dart';
import 'package:task_logger/domain/models/result/result.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/domain/models/update_task_result/update_task_result.dart';
import 'package:task_logger/domain/usecases/params/create_tasks_params/create_tasks_params.dart';
import 'package:task_logger/domain/usecases/params/delete_tasks_params/delete_tasks_params.dart';
import 'package:task_logger/domain/usecases/params/get_tasks_params/get_tasks_params.dart';
import 'package:task_logger/domain/usecases/params/update_tasks_params/update_tasks_params.dart';

abstract class TaskRepository {
  Future<Result<List<Task>>> getTasks(GetTasksParams params);
  Future<Result<BaseResponse<DeleteTaskResult>>> deleteTasks(
      DeleteTasksParams params);
  Future<Result<BaseResponse<List<Task>>>> createTasks(
      CreateTasksParams params);
  Future<Result<BaseResponse<UpdateTaskResult>>> updateTasks(
      UpdateTasksParams params);

  Stream<List<Task>> watchTasks();
  Future<Result<bool>> syncLocalTasks(List<TaskDTO> tasks);
}
