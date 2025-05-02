import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:task_logger/data/database/dao/task_dao/task_dao.drift.dart';
import 'package:task_logger/data/database/database.dart';
import 'package:task_logger/data/database/tables.dart';
import 'package:task_logger/data/database/tables.drift.dart';
import 'package:task_logger/data/dto/task_dto/task_dto.dart';
import 'package:task_logger/domain/models/task/task.dart';

@DriftAccessor(tables: [TaskTable, UpdatedTaskTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with $TaskDaoMixin {
  TaskDao(super.attachedDatabase);

  Future<bool> insertTasks(List<TaskDTO> tasks) {
    final mappedTasks = tasks
        .map((e) => TaskTableCompanion.insert(
              id: Value.absentIfNull(e.id),
              title: e.title,
              date: Value.absentIfNull(e.dateTime),
              description: e.description,
              completed: Value.absentIfNull(e.completed),
              createdAt: Value.absentIfNull(e.createdAt),
              updatedAt: Value.absentIfNull(e.updatedAt),
              isUploaded: Value.absentIfNull(e.isUploaded),
            ))
        .toList();
    return transaction(() async {
      final existingTasks = await select(taskTable).get();

      final newTasks = mappedTasks.where((element) {
        final exists =
            existingTasks.where((e) => e.id == element.id.value).firstOrNull;
        if (exists == null) {
          return true;
        }

        final override = element.updatedAt.value.isAfter(exists.updatedAt!) &&
            exists.isUploaded == true;

        return override;
      }).toList();

      await batch((batch) {
        batch.insertAll(
          taskTable,
          newTasks,
          mode: InsertMode.insertOrReplace,
        );
        // onConflict: DoUpdate<TaskTable, TaskDTO>((t) => t));
      });
    }).then((_) => true).catchError((_) => false);
  }

  Future<bool> deleteTasks(List<String> ids) => transaction(() async {
        final numberOfAffectedRows =
            await (delete(taskTable)..where((tbl) => tbl.id.isIn(ids))).go();
        return numberOfAffectedRows > 0;
      });

  /// Deletes the tasks in the task table
  Future<bool> softDeleteTasks(List<String> ids) async {
    final tasksInCloudAlready = await (select(taskTable)
          ..where((tbl) => tbl.id.isIn(ids) & tbl.isUploaded.equals(true)))
        .get();
    if (tasksInCloudAlready.isNotEmpty) {
      return updateTasks(tasksInCloudAlready
          .map((e) => e.copyWith(isDeleted: true, isUploaded: false))
          .toList(growable: false));
    }
    return deleteTasks(ids);
  }

  /// Updates the tasks in the task table
  /// and inserts the ids of the updated tasks
  /// into the updated_task_table
  Future<bool> updateTasks(List<TaskDTO> tasks) {
    final mappedTasks = tasks
        .map((e) => TaskTableCompanion(
            id: Value.absentIfNull(e.id),
            title: Value(e.title),
            date: Value.absentIfNull(e.dateTime),
            description: Value.absentIfNull(e.description),
            completed: Value.absentIfNull(e.completed),
            createdAt: Value.absentIfNull(e.createdAt),
            updatedAt: Value.absentIfNull(e.updatedAt),
            isUploaded: Value.absentIfNull(e.isUploaded),
            isDeleted: Value.absentIfNull(e.isDeleted)))
        .toList();
    return transaction(() async {
      await batch((batch) {
        batch
          ..insertAll(
            updatedTaskTable,
            mappedTasks
                .map((e) => UpdatedTaskTableCompanion.insert(id: e.id.value))
                .toList(),
            mode: InsertMode.insertOrReplace,
          )
          ..replaceAll(
            taskTable,
            mappedTasks,
          );
        // onConflict: DoUpdate<TaskTable, TaskDTO>((t) => t));
      });
    }).then((_) => true).catchError((e) {
      log(e.toString());
      return false;
    });
  }

  /// Returns a stream of tasks
  /// When there are changes in the task table
  /// the stream emits the new tasks
  Stream<List<Task>> watchTasks() {
    return customSelect('SELECT * from task_table where is_deleted = 0', readsFrom: {
      taskTable
    }).watch().map((event) => event.map((e) {
          e.data['completed'] = e.data['completed'] == 1;
          e.data['dateTime'] = e.data['date_time'];
          e.data['createdAt'] = e.data['created_at'];
          e.data['updatedAt'] = e.data['updated_at'];
          e.data['isDeleted'] = e.data['is_deleted'] == 1;
          e.data['isUploaded'] = e.data['is_uploaded'] == 1;
          return Task.fromJson(e.data);
        }).toList(growable: false));
  }

  /// Gets the tasks that are not deleted
  Future<List<Task>> getTasks(List<String> ids) async {
    final res = await customSelect(
        'SELECT * from task_table where is_deleted = 0 and _id in(${ids.map((e) => "'$e'").join(',')})',
        readsFrom: {taskTable}).map((e) {
      e.data['completed'] = e.data['completed'] == 1;
      e.data['dateTime'] = e.data['date_time'];
      e.data['createdAt'] = e.data['created_at'];
      e.data['updatedAt'] = e.data['updated_at'];
      e.data['isDeleted'] = e.data['is_deleted'] == 1;
      e.data['isUploaded'] = e.data['is_uploaded'] == 1;
      return Task.fromJson(e.data);
    }).get();

    return res;
  }

  /// Gets the tasks that are locally created
  /// and not uploaded to the cloud
  Future<List<TaskDTO>> getLocallyCreatedTasks() async {
    final res = await customSelect(
        'SELECT * from task_table where is_deleted = 0 and is_uploaded = 0 and _id not in (select _id from updated_task_table)',
        readsFrom: {taskTable}).map((e) {
      e.data['completed'] = e.data['completed'] == 1;
      e.data['dateTime'] = e.data['date_time'];
      e.data['createdAt'] = e.data['created_at'];
      e.data['updatedAt'] = e.data['updated_at'];
      e.data['isDeleted'] = e.data['is_deleted'] == 1;
      e.data['isUploaded'] = e.data['is_uploaded'] == 1;
      return TaskDTO.fromJson(e.data);
    }).get();

    return res;
  }

  /// Gets the tasks that are locally deleted
  /// and not uploaded to the cloud
  Future<List<TaskDTO>> getSoftDeletedTasks() async {
    final res = await customSelect(
        'SELECT * from task_table where is_deleted = 1 and is_uploaded = 0',
        readsFrom: {taskTable}).map((e) {
      e.data['completed'] = e.data['completed'] == 1;
      e.data['dateTime'] = e.data['date_time'];
      e.data['createdAt'] = e.data['created_at'];
      e.data['updatedAt'] = e.data['updated_at'];
      e.data['isDeleted'] = e.data['is_deleted'] == 1;
      e.data['isUploaded'] = e.data['is_uploaded'] == 1;
      return TaskDTO.fromJson(e.data);
    }).get();

    return res;
  }

  /// Gets the tasks that are locally updated
  /// and not uploaded to the cloud
  Future<List<TaskDTO>> getLocallyUpdatedTasks() async {
    final res = await customSelect(
        'SELECT * from task_table as t join updated_task_table as ut on t._id = ut._id where t.is_uploaded = 0 and t.is_deleted = 0',
        readsFrom: {updatedTaskTable}).map((e) {
      e.data['completed'] = e.data['completed'] == 1;
      e.data['dateTime'] = e.data['date_time'];
      e.data['createdAt'] = e.data['created_at'];
      e.data['updatedAt'] = e.data['updated_at'];
      e.data['isDeleted'] = e.data['is_deleted'] == 1;
      e.data['isUploaded'] = e.data['is_uploaded'] == 1;
      return TaskDTO.fromJson(e.data);
    }).get();

    return res;
  }

  /// Deletes the ids saved from the updated_task_table
  /// when locally updated tasks are synced to the cloud
  Future<bool> deleteUpdatedTasks(List<String> ids) async {
    final res =
        await (delete(updatedTaskTable)..where((tbl) => tbl.id.isIn(ids))).go();
    return res > 0;
  }
}
