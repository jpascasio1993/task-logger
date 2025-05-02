import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_logger/core/enums/internet_connection_status.dart';
import 'package:task_logger/core/extensions/localization_extension.dart';
import 'package:task_logger/core/extensions/theme_extension.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/core/widgets/base_widgets/widget_view.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/features/bloc/app_state_bloc/app_state.dart';
import 'package:task_logger/features/bloc/app_state_bloc/app_state_bloc.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_bloc.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_event.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_state.dart';
import 'package:task_logger/features/mixins/bloc/create_task_bloc_mixin.dart';
import 'package:task_logger/router/new_task_route/new_task_route.dart';
import 'package:task_logger/router/update_task_route/update_task_route.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardController();
}

class _DashboardController extends BaseState<Dashboard>
    with CreateTaskBlocMixin {
  @override
  void initState() {
    super.initState();
    init();
    watchTasks();
  }

  @override
  Widget buildView(BuildContext context) => MultiBlocListener(listeners: [
        BlocListener<DashboardTaskBloc, DashboardTaskState>(
          listenWhen: (previous, current) =>
              previous.deleteTaskLoading != current.deleteTaskLoading &&
              current.deleteTaskLoading,
          listener: (context, state) =>
              ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.localization.deletingTask),
            ),
          ),
        ),
        BlocListener<DashboardTaskBloc, DashboardTaskState>(
          listenWhen: (previous, current) =>
              previous.deleteTaskResult != current.deleteTaskResult &&
              current.deleteTaskResult != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.deleteTaskResult!.message),
              ),
            );
          },
        ),
        BlocListener<AppStateBloc, AppState>(
          listenWhen: (previous, current) =>
              previous.internetConnectionStatus !=
                  current.internetConnectionStatus &&
              current.internetConnectionStatus ==
                  InternetConnectionStatus.connected,
          listener: (context, state) {
            init();
            syncRemoteTasks();
          },
        ),
        BlocListener<AppStateBloc, AppState>(
          listenWhen: (previous, current) =>
              previous.appLifecycleState != current.appLifecycleState &&
              current.appLifecycleState == AppLifecycleState.resumed &&
              current.internetConnectionStatus ==
                  InternetConnectionStatus.connected,
          listener: (context, state) {
            init();
            syncRemoteTasks();
          },
        ),
      ], child: _DashboardView(this));

  void init() {
    super.taskBloc.add(const DashboardTaskEvent.getTasksFromRemote());
  }

  void watchTasks() {
    super.taskBloc.add(const DashboardTaskEvent.watchTasks());
  }

  void delete(List<String> ids) {
    super.taskBloc.add(DashboardTaskEvent.delete(ids));
  }

  void syncRemoteTasks() {
    super.taskBloc.add(const DashboardTaskEvent.syncRemoteTasks());
  }

  Future<void> update(Task task) async {
    final res =
        (await UpdateTaskRoute(task.id, task).push<bool?>(context)) ?? false;
    if (!res) return;
    init();
  }
}

class _DashboardView extends WidgetView<Dashboard, _DashboardController> {
  const _DashboardView(super.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.localization.appName),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  final res =
                      (await NewTaskRoute().push<bool?>(context)) ?? false;
                  if (!res) return;
                  state.init();
                },
                icon: const Icon(Icons.add))
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 10),
            child: Builder(
              builder: (context) {
                final connected = context.select<AppStateBloc, bool>((bloc) =>
                    bloc.state.internetConnectionStatus ==
                    InternetConnectionStatus.connected);
                return AnimatedOpacity(
                  opacity: connected ? 0 : 1,
                  duration: kThemeAnimationDuration,
                  child: ColoredBox(
                      color: Colors.red,
                      child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            context.localization.noInternetConnection,
                            style: context.materialTheme.textTheme.labelSmall
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ))),
                );
              },
            ),
          ),
        ),
        body: SafeArea(child: Builder(
          builder: (context) {
            final isLoading = context.select<DashboardTaskBloc, bool>(
                (bloc) => bloc.state.getTasksLoading);
            // final error = context.select<DashboardTaskBloc, BaseException?>(
            //     (bloc) => bloc.state.getTasksException);
            final tasks = context.select<DashboardTaskBloc, List<Task>>(
                (bloc) => bloc.state.tasks);

            if (isLoading && tasks.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (tasks.isEmpty) {
              return Center(
                  child: Text(
                context.localization.nothingToShow,
                style: context.materialTheme.textTheme.labelLarge,
              ));
            }

            return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      await state.update(tasks[index]);
                    },
                    title: Text(tasks[index].title,
                        style: context.materialTheme.textTheme.labelLarge
                            ?.copyWith(
                                color:
                                    context.materialTheme.colorScheme.primary)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                              await state.update(tasks[index]);
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              state.delete([tasks[index].id]);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tasks[index].description,
                            style: context.materialTheme.textTheme.labelMedium
                                ?.copyWith(
                                    color: context
                                        .materialTheme.colorScheme.onSurface)),
                        Text(
                          context.localization
                              .isCompleted(tasks[index].completed.toString()),
                          style: context.materialTheme.textTheme.labelMedium
                              ?.copyWith(
                                  color: context
                                      .materialTheme.colorScheme.onSurface),
                        ),
                        // Text(tasks[index].dateTime.toLocal().toString()),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: tasks.length);
          },
        )));
  }
}
