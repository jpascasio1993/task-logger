import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_logger/core/enums/internet_connection_status.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState(
      {@Default(Brightness.light) Brightness brightness,
      @Default(AppLifecycleState.inactive) AppLifecycleState appLifecycleState,
      @Default(InternetConnectionStatus.disconnected)
      InternetConnectionStatus internetConnectionStatus,
      @Default(false) bool apiHealthCheckerSubscribed,
      @Default(false) bool updateDialogIsShowing,
      @Default(false) bool isAppInstantiatedInactiveState,
      @Default(false) bool isCheckingFreshInstallFlag}) = _AppState;
}
