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

        final override = element.updatedAt.value.isAfter(exists.updatedAt!);

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

  Future<int> deleteTasks(List<String> ids) => transaction(() async {
        final numberOfAffectedRows =
            await (delete(taskTable)..where((tbl) => tbl.id.isIn(ids))).go();
        return numberOfAffectedRows;
      });

  Stream<List<Task>> watchTasks() {
    return customSelect('SELECT * from task_table', readsFrom: {taskTable})
        .watch()
        .map((event) => event.map((e) {
              e.data['completed'] = e.data['completed'] == 1;
              e.data['dateTime'] = e.data['date_time'];
              e.data['createdAt'] = e.data['created_at'];
              e.data['updatedAt'] = e.data['updated_at'];
              return TaskDTO.fromJson(e.data);
            }))
        .map((dtos) =>
            dtos.map((e) => Task.fromJson(e.toJson())).toList(growable: false));
  }

  Future<List<Task>> getTasks(List<String> ids) async {
    final res =
        await (select(taskTable)..where((tbl) => tbl.id.isIn(ids))).get();
    return res.map((e) => Task.fromJson(e.toJson())).toList(growable: false);
  }
}
