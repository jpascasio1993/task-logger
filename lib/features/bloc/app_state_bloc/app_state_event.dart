import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/core/enums/internet_connection_status.dart';

part 'app_state_event.freezed.dart';

@freezed
sealed class AppStateEvent with _$AppStateEvent {
  const factory AppStateEvent.subscribeToAPIHealth() =
      AppStateEventSubscribeToAPIHealth;
  const factory AppStateEvent.updateInternetConnectionStatus(
          InternetConnectionStatus status) =
      AppStateEventUpdateInternetConnectionStatus;
  const factory AppStateEvent.updateBrightness(Brightness brightness) =
      AppStateEventUpdateBrightness;
  const factory AppStateEvent.updateAppLifecycleState(
          AppLifecycleState appLifecycleState) =
      AppStateEventUpdateAppLifecycleState;
}
