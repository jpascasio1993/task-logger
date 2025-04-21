import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

abstract class BaseState<E extends StatefulWidget> extends State<E> {
  @visibleForOverriding
  List<BlocProvider> get blocs => [];

  @mustBeOverridden
  Widget buildView(BuildContext context);

  @nonVirtual
  @override
  Widget build(BuildContext context) {
    if (blocs.isEmpty) {
      return buildView(context);
    }
    return MultiBlocProvider(
        providers: blocs.toList(growable: false),
        child: Builder(builder: buildView));
  }
}
