// coverage:ignore-file
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/features/bloc/update_task_bloc/update_task_bloc.dart';

mixin CreateUpdateTaskBlocMixin<E extends StatefulWidget> on BaseState<E> {
  late UpdateTaskBloc updateTaskBloc;

  @override
  void initState() {
    super.initState();
    final serviceLocator = context.read<GetIt>();
    updateTaskBloc = serviceLocator<UpdateTaskBloc>();
  }

  @override
  List<BlocProvider<StateStreamableSource<Object?>>> get blocs => [
        BlocProvider<UpdateTaskBloc>.value(value: updateTaskBloc),
        ...super.blocs
      ];

  @override
  void dispose() {
    Future.sync(() async {
      await updateTaskBloc.close();
    });
    super.dispose();
  }
}
