import 'package:task_logger/data/database/dao/task_dao/task_dao.dart';
import 'package:task_logger/data/database/database.dart';

abstract class DatabaseModule {
  AppDatabase get appDatabase;
  TaskDao taskDao(AppDatabase appDatabase);
}
