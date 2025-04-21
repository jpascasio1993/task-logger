import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_logger/features/dashboard/dashboard.dart';
import 'package:task_logger/router/router.dart';

part 'dashboard_route.g.dart';

@TypedGoRoute<DashboardRoute>(path: '/')
class DashboardRoute extends BaseRoute<void> {
  @override
  ScreenRoute screen(BuildContext context) {
    return ScreenRoute(builder: (context, state) => const Dashboard());
  }
}
