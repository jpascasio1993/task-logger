import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_logger/core/enums/internet_connection_status.dart';
import 'package:task_logger/core/enums/response_type.dart';
import 'package:task_logger/core/extensions/localization_extension.dart';
import 'package:task_logger/core/extensions/theme_extension.dart';
import 'package:task_logger/core/utils/dio/exceptions/base_exception.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/core/widgets/base_widgets/widget_view.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/features/bloc/app_state_bloc/app_state.dart';
import 'package:task_logger/features/bloc/app_state_bloc/app_state_bloc.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_bloc.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_event.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_state.dart';
import 'package:task_logger/features/bloc/new_task_bloc/new_task_bloc.dart';
import 'package:task_logger/features/bloc/new_task_bloc/new_task_state.dart';
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

            if (state.deleteTaskResult!.type == ResponseType.error) return;
            init();
          },
        ),
        BlocListener<NewTaskBloc, NewTaskState>(
          listenWhen: (previous, current) =>
              previous.createTaskResult != current.createTaskResult &&
              current.createTaskResult != null &&
              current.exception != null,
          listener: (context, state) {
            init();
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
        ),
        body: SafeArea(child: Builder(
          builder: (context) {
            final isLoading = context.select<DashboardTaskBloc, bool>(
                (bloc) => bloc.state.getTasksLoading);
            final error = context.select<DashboardTaskBloc, BaseException?>(
                (bloc) => bloc.state.getTasksException);
            final tasks = context.select<DashboardTaskBloc, List<Task>>(
                (bloc) => bloc.state.tasks);

            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (error != null) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(error.message),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                        onPressed: state.init,
                        child: Text(context.localization.retry)),
                  ],
                ),
              );
            }

            return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      final res =
                          (await UpdateTaskRoute(tasks[index].id, tasks[index])
                                  .push<bool?>(context)) ??
                              false;
                      if (!res) return;
                      state.init();
                    },
                    title: Text(tasks[index].title,
                        style: context.materialTheme.textTheme.labelLarge
                            ?.copyWith(
                                color:
                                    context.materialTheme.colorScheme.primary)),
                    trailing: IconButton(
                        onPressed: () {
                          state.delete([tasks[index].id]);
                        },
                        icon: const Icon(Icons.delete)),
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
                              .isCompleted(tasks[index].completed),
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
