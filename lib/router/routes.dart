import 'package:task_logger/router/dashboard_route/dashboard_route.dart'
    as dashboard_route;
import 'package:task_logger/router/new_task_route/new_task_route.dart'
    as new_task_route;
import 'package:task_logger/router/update_task_route/update_task_route.dart'
    as update_task_route;

final routes = [
  ...dashboard_route.$appRoutes,
  ...new_task_route.$appRoutes,
  ...update_task_route.$appRoutes,
];
