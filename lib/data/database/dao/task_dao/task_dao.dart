import 'package:drift/drift.dart';
import 'package:task_logger/data/database/dao/task_dao/task_dao.drift.dart';
import 'package:task_logger/data/database/database.dart';
import 'package:task_logger/data/database/tables.dart';
import 'package:task_logger/data/database/tables.drift.dart';
import 'package:task_logger/data/dto/task_dto/task_dto.dart';
import 'package:task_logger/domain/models/task/task.dart';

@DriftAccessor(tables: [TaskTable])
class TaskDao extends DatabaseAccessor<AppDatabase> with $TaskDaoMixin {
  TaskDao(super.attachedDatabase);

  Future<bool> insertTasks(List<TaskDTO> tasks) {
    final mappedTasks = tasks
        .map((e) => TaskTableCompanion.insert(
              id: Value.absentIfNull(e.id),
              title: Value(e.title),
              date: Value.absentIfNull(e.dateTime),
              description: Value.absentIfNull(e.description),
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
        batch.replaceAll(
          taskTable,
          mappedTasks,
        );
        // onConflict: DoUpdate<TaskTable, TaskDTO>((t) => t));
      });
    }).then((_) => true).catchError((_) => false);
  }

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

  Future<List<Task>> getTasks(List<String> ids) async {
    // final res =
    //     await (select(taskTable)..where((tbl) => tbl.id.isIn(ids))).get();
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

  Future<List<TaskDTO>> getLocallyCreatedTasks() async {
    final res = await customSelect(
        'SELECT * from task_table where is_deleted = 0 and is_uploaded = 0',
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
}
