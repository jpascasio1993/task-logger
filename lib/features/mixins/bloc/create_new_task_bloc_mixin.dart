// coverage:ignore-file
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/features/bloc/new_task_bloc/new_task_bloc.dart';

mixin CreateNewTaskBlocMixin<E extends StatefulWidget> on BaseState<E> {
  late NewTaskBloc newTaskBloc;

  @override
  void initState() {
    super.initState();
    final serviceLocator = context.read<GetIt>();
    newTaskBloc = serviceLocator<NewTaskBloc>();
  }

  @override
  List<BlocProvider<StateStreamableSource<Object?>>> get blocs =>
      [BlocProvider<NewTaskBloc>.value(value: newTaskBloc), ...super.blocs];

  @override
  void dispose() {
    unawaited(newTaskBloc.close());
    super.dispose();
  }
}
