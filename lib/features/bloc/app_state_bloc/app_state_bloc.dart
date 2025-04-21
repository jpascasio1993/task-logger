import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_logger/core/enums/internet_connection_status.dart';
import 'package:task_logger/domain/repositories/api_health_repository.dart';
import 'package:task_logger/features/bloc/app_state_bloc/app_state.dart';
import 'package:task_logger/features/bloc/app_state_bloc/app_state_event.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppState> {
  AppStateBloc(this._apiHealthRepository) : super(const AppState()) {
    on<AppStateEventSubscribeToAPIHealth>((event, emit) async {
      if (state.apiHealthCheckerSubscribed) {
        unawaited(_streamSubscription?.cancel());
        _streamSubscription = null;
      }

      _apiHealthCheckerStream =
          _apiHealthRepository.onStatusChange.asBroadcastStream();
      _streamSubscription = _apiHealthCheckerStream!
          .doOnListen(() {
            emit(state.copyWith(apiHealthCheckerSubscribed: true));
          })
          .doOnCancel(() {
            if (emit.isDone) return;
            emit(state.copyWith(apiHealthCheckerSubscribed: false));
          })
          .distinct()
          .listen((status) {
            add(AppStateEvent.updateInternetConnectionStatus(status));
          });

      final initialConnectionResult = await _apiHealthRepository.hasConnection;

      add(AppStateEvent.updateInternetConnectionStatus(initialConnectionResult
          ? InternetConnectionStatus.connected
          : InternetConnectionStatus.disconnected));
    });
    on<AppStateEventUpdateInternetConnectionStatus>((event, emit) {
      emit(state.copyWith(internetConnectionStatus: event.status));
    });
    on<AppStateEventUpdateBrightness>((event, emit) {
      emit(state.copyWith(brightness: event.brightness));
    });
    on<AppStateEventUpdateAppLifecycleState>((event, emit) {
      emit(state.copyWith(appLifecycleState: event.appLifecycleState));
    });
  }

  final ApiHealthRepository _apiHealthRepository;

  late Stream<InternetConnectionStatus>? _apiHealthCheckerStream;

  late StreamSubscription<InternetConnectionStatus>? _streamSubscription;

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
