import 'package:drift/drift.dart';
import 'package:objectid/objectid.dart';
import 'package:task_logger/data/dto/task_dto/task_dto.dart';

@UseRowClass(TaskDTO)
class TaskTable extends Table {
  TextColumn get id =>
      text().named('_id').clientDefault(() => ObjectId().hexString)();

  TextColumn get title => text().nullable()();

  TextColumn get description => text().nullable()();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  DateTimeColumn get date =>
      dateTime().withDefault(currentDateAndTime).named('date_time')();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isUploaded => boolean().withDefault(const Constant(false))();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  BoolColumn get isUpdated => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
