import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_logger/core/enums/response_type.dart';
import 'package:task_logger/core/extensions/localization_extension.dart';
import 'package:task_logger/core/extensions/theme_extension.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/core/widgets/base_widgets/widget_view.dart';
import 'package:task_logger/domain/models/task/task.dart';
import 'package:task_logger/features/bloc/form_task_view_state_bloc/form_task_view_state_bloc.dart';
import 'package:task_logger/features/bloc/form_task_view_state_bloc/form_task_view_state_event.dart';
import 'package:task_logger/features/bloc/update_task_bloc/update_task_bloc.dart';
import 'package:task_logger/features/bloc/update_task_bloc/update_task_event.dart';
import 'package:task_logger/features/bloc/update_task_bloc/update_task_state.dart';
import 'package:task_logger/features/mixins/bloc/create_form_task_view_state_bloc_mixin.dart';
import 'package:task_logger/features/mixins/bloc/create_update_task_bloc_mixin.dart';

class UpdateTask extends StatefulWidget {
  const UpdateTask({super.key, required this.task});

  final Task task;

  @override
  State<UpdateTask> createState() => _UpdateTaskController();
}

class _UpdateTaskController extends BaseState<UpdateTask>
    with CreateFormTaskViewStateBlocMixin, CreateUpdateTaskBlocMixin {
  @override
  void initState() {
    super.initState();
    formTaskViewStateBloc.add(FormTaskViewStateEvent.title(widget.task.title));
    formTaskViewStateBloc
        .add(FormTaskViewStateEvent.description(widget.task.description));
    formTaskViewStateBloc
        .add(FormTaskViewStateEvent.completed(widget.task.completed));
    formTaskViewStateBloc
        .add(FormTaskViewStateEvent.dateTime(widget.task.dateTime));
  }

  @override
  Widget buildView(BuildContext context) => MultiBlocListener(listeners: [
        BlocListener<UpdateTaskBloc, UpdateTaskState>(
          listenWhen: (previous, current) =>
              previous.updateTaskResult != current.updateTaskResult &&
              current.updateTaskResult != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.updateTaskResult!.message),
              ),
            );
            if (state.updateTaskResult!.type == ResponseType.error) return;
            context.pop(true);
          },
        ),
      ], child: _UpdateTaskView(this));
}

class _UpdateTaskView extends WidgetView<UpdateTask, _UpdateTaskController> {
  const _UpdateTaskView(super.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.localization.updateTask),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: widget.task.title,
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
                initialValue: widget.task.description,
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
                      state.updateTaskBloc.add(UpdateTaskEvent(
                          id: widget.task.id,
                          title: state.formTaskViewStateBloc.state.title ?? '',
                          description:
                              state.formTaskViewStateBloc.state.description ??
                                  '',
                          completed:
                              state.formTaskViewStateBloc.state.completed,
                          dateTime:
                              state.formTaskViewStateBloc.state.dateTime));
                    },
                    child: Text(context.localization.updateTask)),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )));
  }
}
