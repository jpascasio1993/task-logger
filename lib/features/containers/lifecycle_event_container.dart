import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:task_logger/core/widgets/base_widgets/base_state.dart';
import 'package:task_logger/core/widgets/base_widgets/widget_view.dart';
import 'package:task_logger/features/bloc/app_state_bloc/app_state_event.dart';
import 'package:task_logger/features/mixins/bloc/create_app_state_bloc_mixin.dart';

class LifecycleEventContainer extends StatefulWidget {
  const LifecycleEventContainer({super.key, required this.child});

  final Widget child;

  @override
  BaseState<LifecycleEventContainer> createState() =>
      _LifecycleEventContainerController();
}

class _LifecycleEventContainerController
    extends BaseState<LifecycleEventContainer>
    with WidgetsBindingObserver, CreateAppStateBlocMixin {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    /// Executes postBuild after the widgets are done rendering for the first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(postBuild());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = PlatformDispatcher.instance.platformBrightness;
    super.appStateBloc.add(AppStateEvent.updateBrightness(brightness));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.appStateBloc.add(AppStateEvent.updateAppLifecycleState(state));
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    super.appStateBloc.add(AppStateEvent.updateBrightness(brightness));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> postBuild() async {
    if (_initialized) return;
    _initialized = true;
    super.appStateBloc.add(
        const AppStateEvent.updateAppLifecycleState(AppLifecycleState.resumed));
    super.appStateBloc.add(const AppStateEvent.subscribeToAPIHealth());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget buildView(BuildContext context) => _LifecycleEventContainerView(this);
}

class _LifecycleEventContainerView extends WidgetView<LifecycleEventContainer,
    _LifecycleEventContainerController> {
  const _LifecycleEventContainerView(super.state);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: widget.child);
  }
}
