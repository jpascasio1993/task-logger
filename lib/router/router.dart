import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:task_logger/core/constants.dart';
import 'package:task_logger/router/routes.dart';

typedef Builder = Widget Function(
    BuildContext context, GoRouterState routerState);

class ScreenRoute {
  ScreenRoute({required this.builder});
  Builder builder;
}

GoRouter getRouter([String? initialLocation]) => GoRouter(
    routes: routes,
    initialLocation: initialLocation ?? '/',
    navigatorKey: rootNavigatorKey,
    redirect: _handleRedirect);

String? _handleRedirect(BuildContext context, GoRouterState state) {
  // Prevent from navigating away from `/` if app is starting up
  return null;
}

abstract class BaseRoute<T> extends GoRouteData {
  ScreenRoute screen(BuildContext context);

  String get name => runtimeType.toString();

  @override
  Page<T> buildPage(BuildContext context, GoRouterState state) {
    final child = screen(context);
    return CupertinoPage<T>(
        key: state.pageKey, child: child.builder(context, state));
  }
}
