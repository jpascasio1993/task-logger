// coverage:ignore-file
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/features/bloc/form_task_view_state_bloc/form_task_view_state_bloc.dart';

mixin CreateFormTaskViewStateBlocMixin<E extends StatefulWidget>
    on BaseState<E> {
  late FormTaskViewStateBloc formTaskViewStateBloc;

  @override
  void initState() {
    super.initState();
    final serviceLocator = context.read<GetIt>();
    formTaskViewStateBloc = serviceLocator<FormTaskViewStateBloc>();
  }

  @override
  List<BlocProvider<StateStreamableSource<Object?>>> get blocs => [
        BlocProvider<FormTaskViewStateBloc>.value(value: formTaskViewStateBloc),
        ...super.blocs
      ];

  @override
  void dispose() {
    Future.sync(() async {
      await formTaskViewStateBloc.close();
    });
    super.dispose();
  }
}
