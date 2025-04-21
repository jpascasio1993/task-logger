// coverage:ignore-file
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/features/bloc/dashboard_task_bloc/dashboard_task_bloc.dart';

mixin CreateTaskBlocMixin<E extends StatefulWidget> on BaseState<E> {
  late DashboardTaskBloc taskBloc;

  @override
  void initState() {
    super.initState();
    final serviceLocator = context.read<GetIt>();
    taskBloc = serviceLocator<DashboardTaskBloc>();
  }

  @override
  List<BlocProvider<StateStreamableSource<Object?>>> get blocs =>
      [BlocProvider<DashboardTaskBloc>.value(value: taskBloc), ...super.blocs];

  @override
  void dispose() {
    Future.sync(() async {
      await taskBloc.close();
    });
    super.dispose();
  }
}
