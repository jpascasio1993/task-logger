import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/features/bloc/app_state_bloc/app_state_bloc.dart';

mixin CreateAppStateBlocMixin<E extends StatefulWidget> on BaseState<E> {
  late AppStateBloc appStateBloc;

  @override
  void initState() {
    super.initState();
    final serviceLocator = context.read<GetIt>();
    appStateBloc = serviceLocator<AppStateBloc>();
  }

  @override
  List<BlocProvider<StateStreamableSource<Object?>>> get blocs =>
      [BlocProvider<AppStateBloc>.value(value: appStateBloc), ...super.blocs];

  @override
  void dispose() {
    Future.sync(() async {
      await appStateBloc.close();
    });
    super.dispose();
  }
}
