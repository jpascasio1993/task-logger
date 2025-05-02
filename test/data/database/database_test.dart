import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_logger/data/database/dao/task_dao/task_dao.dart';
import 'package:task_logger/data/database/database.dart';
import 'package:task_logger/data/dto/task_dto/task_dto.dart';
import 'package:task_logger/domain/models/task/task.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  late AppDatabase appDatabase;
  late TaskDao taskDao;
  late TaskDTO taskDTO;
  setUp(() {
    final task =
        Task.fromJson(jsonDecode(Fixtures.task) as Map<String, dynamic>);
    taskDTO = TaskDTO(
      id: task.id,
      title: task.title,
      description: task.description,
      completed: task.completed,
      dateTime: task.dateTime,
    );

    appDatabase = AppDatabase.testing(NativeDatabase.memory());
    taskDao = TaskDao(appDatabase);
  });

  tearDown(() async {
    await appDatabase.close();
  });

  group('TaskDao test', () {
    // Success cases
    test('should create a task successfully', () async {
      final result = await taskDao.insertTasks([taskDTO]);
      expect(result, isTrue);

      // Verify task was actually inserted
      final tasks = await taskDao.getTasks([taskDTO.id!]);
      expect(tasks, hasLength(1));
      expect(tasks.first.id, equals(taskDTO.id));
    });

    test('should update a task successfully', () async {
      // First insert a task
      await taskDao.insertTasks([taskDTO]);

      // Create updated version of the task
      final updatedTask = taskDTO.copyWith(
          title: 'Updated Title',
          description: 'Updated Description',
          completed: true);

      // Update the task
      final result = await taskDao.updateTasks([updatedTask]);
      expect(result, isTrue);

      // Verify the update
      final tasks = await taskDao.getTasks([taskDTO.id!]);
      expect(tasks, hasLength(1));
      expect(tasks.first.title, equals('Updated Title'));
      expect(tasks.first.description, equals('Updated Description'));
      expect(tasks.first.completed, isTrue);
    });

    test('should delete a task successfully', () async {
      // First insert a task
      await taskDao.insertTasks([taskDTO]);

      // Delete the task
      final result = await taskDao.deleteTasks([taskDTO.id!]);
      expect(result, isTrue);

      // Verify the deletion
      final tasks = await taskDao.getTasks([taskDTO.id!]);
      expect(tasks, isEmpty);
    });

    test('should soft delete a task successfully', () async {
      // First insert a task with isUploaded = true
      final uploadedTask = taskDTO.copyWith(isUploaded: true);
      await taskDao.insertTasks([uploadedTask]);

      // Soft delete the task
      final result = await taskDao.softDeleteTasks([uploadedTask.id!]);
      expect(result, isTrue);

      // Verify the soft deletion
      final deletedTasks = await taskDao.getSoftDeletedTasks();
      expect(deletedTasks, hasLength(1));
      expect(deletedTasks.first.id, equals(uploadedTask.id));
      expect(deletedTasks.first.isDeleted, isTrue);
    });

    test('should fail to update non-existent task', () async {
      final nonExistentTask = taskDTO.copyWith(id: 'non_existent_id');
      final result = await taskDao.updateTasks([nonExistentTask]);
      expect(result, isTrue);
      final tasks = await taskDao.getTasks([nonExistentTask.id!]);
      expect(tasks, isEmpty);
    });

    test('should fail to delete non-existent task', () async {
      final result = await taskDao.deleteTasks(['non_existent_id']);
      expect(result, isFalse);
    });

    test('should handle empty list for batch operations', () async {
      final insertResult = await taskDao.insertTasks([]);
      expect(insertResult, isTrue);

      final updateResult = await taskDao.updateTasks([]);
      expect(updateResult, isTrue);

      final deleteResult = await taskDao.deleteTasks([]);
      expect(deleteResult, isFalse);
    });
  });
}
