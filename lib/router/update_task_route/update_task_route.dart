import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/features/update_task.dart/update_task.dart';
import 'package:task_logger/router/router.dart';

part 'update_task_route.g.dart';

@TypedGoRoute<UpdateTaskRoute>(path: '/update-task')
class UpdateTaskRoute extends BaseRoute<bool?> {
  UpdateTaskRoute(this.id, this.$extra);

  final String id;
  final Task $extra;

  @override
  ScreenRoute screen(BuildContext context) {
    return ScreenRoute(builder: (context, state) => UpdateTask(task: $extra));
  }
}
