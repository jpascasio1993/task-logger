// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

abstract class Fixtures {
  static String get createTaskResponse => fixture('create_task_response.json');
  static String get task => fixture('task.json');
  static String get updateTaskResponse => fixture('update_task_response.json');
  static String get deleteTaskResponse => fixture('delete_task_response.json');
  static String get getTaskResponse => fixture('get_task_response.json');
}
