import 'package:injectable/injectable.dart';
import 'package:task_logger/data/database/dao/task_dao/task_dao.dart';
import 'package:task_logger/data/database/database.dart';
import 'package:task_logger/di/modules/database_module/database_module.dart';

@module
abstract class DatabaseModuleImpl implements DatabaseModule {
  @singleton
  @override
  AppDatabase get appDatabase => AppDatabase();

  @singleton
  @override
  TaskDao taskDao(AppDatabase appDatabase) => TaskDao(appDatabase);
}
