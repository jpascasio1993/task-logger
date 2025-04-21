import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:task_logger/features/new_task/new_task.dart';
import 'package:task_logger/router/router.dart';

part 'new_task_route.g.dart';

@TypedGoRoute<NewTaskRoute>(path: '/new-task')
class NewTaskRoute extends BaseRoute<bool?> {
  @override
  ScreenRoute screen(BuildContext context) {
    return ScreenRoute(builder: (context, state) => const NewTask());
  }
}
