import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:path_provider/path_provider.dart';
import 'package:task_logger/data/database/tables.dart';

import 'database.drift.dart';

@DriftDatabase(tables: [TaskTable, UpdatedTaskTable])
class AppDatabase extends $AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.testing(super.e);

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(
      name: 'task_logger',
      native: const DriftNativeOptions(
          shareAcrossIsolates: true,
          databaseDirectory: getApplicationSupportDirectory));
}
