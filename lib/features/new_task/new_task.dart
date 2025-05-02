import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_logger/core/constants.dart';
import 'package:task_logger/core/enums/response_type.dart';
import 'package:task_logger/core/extensions/localization_extension.dart';
import 'package:task_logger/core/extensions/theme_extension.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/core/widgets/base_widgets/widget_view.dart';
import 'package:task_logger/features/bloc/form_task_view_state_bloc/form_task_view_state_bloc.dart';
import 'package:task_logger/features/bloc/form_task_view_state_bloc/form_task_view_state_event.dart';
import 'package:task_logger/features/bloc/new_task_bloc/new_task_bloc.dart';
import 'package:task_logger/features/bloc/new_task_bloc/new_task_event.dart';
import 'package:task_logger/features/bloc/new_task_bloc/new_task_state.dart';
import 'package:task_logger/features/mixins/bloc/create_form_task_view_state_bloc_mixin.dart';
import 'package:task_logger/features/mixins/bloc/create_new_task_bloc_mixin.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskController();
}

class _NewTaskController extends BaseState<NewTask>
    with CreateFormTaskViewStateBlocMixin, CreateNewTaskBlocMixin {
  @override
  Widget buildView(BuildContext context) => MultiBlocListener(listeners: [
        BlocListener<NewTaskBloc, NewTaskState>(
          listenWhen: (previous, current) =>
              previous.isLoading != current.isLoading && current.isLoading,
          listener: (context, state) {
            ScaffoldMessenger.of(rootNavigatorKey.currentContext!).showSnackBar(
              SnackBar(
                content: Text(context.localization.creatingTask),
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
        ),
        BlocListener<NewTaskBloc, NewTaskState>(
          listenWhen: (previous, current) =>
              previous.createTaskResult != current.createTaskResult &&
              current.createTaskResult != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.createTaskResult!.message),
              ),
            );
            if (state.createTaskResult!.type == ResponseType.error) return;
            context.pop(true);
          },
        ),
      ], child: _NewTaskView(this));
}

class _NewTaskView extends WidgetView<NewTask, _NewTaskController> {
  const _NewTaskView(super.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.localization.createNewTask),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onChanged: (value) {
                  state.formTaskViewStateBloc
                      .add(FormTaskViewStateEvent.title(value));
                },
                decoration:
                    InputDecoration(labelText: context.localization.title),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (value) {
                  state.formTaskViewStateBloc
                      .add(FormTaskViewStateEvent.description(value));
                },
                decoration: InputDecoration(
                  labelText: context.localization.description,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Builder(builder: (context) {
                    final isCompleted =
                        context.select<FormTaskViewStateBloc, bool>(
                            (value) => value.state.completed);
                    return Checkbox(
                      value: isCompleted,
                      onChanged: (value) {
                        state.formTaskViewStateBloc
                            .add(FormTaskViewStateEvent.completed(value));
                      },
                    );
                  }),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    context.localization.completed,
                    style: context.materialTheme.textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      context.read<NewTaskBloc>().add(NewTaskEvent(
                          title: state.formTaskViewStateBloc.state.title ?? '',
                          description:
                              state.formTaskViewStateBloc.state.description ??
                                  '',
                          completed:
                              state.formTaskViewStateBloc.state.completed,
                          dateTime:
                              state.formTaskViewStateBloc.state.dateTime));
                    },
                    child: Text(context.localization.createTask)),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )));
  }
}
