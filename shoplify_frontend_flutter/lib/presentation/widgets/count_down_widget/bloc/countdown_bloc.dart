import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/core/constants/constant.dart';

part 'countdown_event.dart';
part 'countdown_state.dart';

class CountdownBloc extends Bloc<CountdownEvent, CountdownState> {
  Timer? _timer;
  VoidCallback? _countdownFinishedCallback;

  CountdownBloc()
      : super(CountdownInitial(secondsRemaining: Constant.otpCountdown)) {
    on<CountdownStartEvent>(_onCountdownStart);
    on<CountdownStopEvent>(_onCountdownStop);
    on<CountdownTickEvent>(_countdownTick);
    on<CountdownFinishedEvent>(_oncountdownFinished);
  }

  void _onCountdownStart(
      CountdownStartEvent event, Emitter<CountdownState> emit) {
    if (state is! CountdownRunning) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        final currentSeconds = state.secondsRemaining;
        if (currentSeconds > 0) {
          add(CountdownTickEvent(secondsRemaining: currentSeconds - 1));
        } else {
          add(CountdownFinishedEvent());
        }
      });

      emit(CountdownRunning(secondsRemaining: state.secondsRemaining));
    }
  }

  void _onCountdownStop(
      CountdownStopEvent event, Emitter<CountdownState> emit) {
    _timer?.cancel();
    emit(CountdownStopped(secondsRemaining: state.secondsRemaining));
  }

  void _countdownTick(CountdownTickEvent event, Emitter<CountdownState> emit) {
    emit(CountdownRunning(secondsRemaining: event.secondsRemaining));
  }

  void _oncountdownFinished(
      CountdownFinishedEvent event, Emitter<CountdownState> emit) {
    _timer?.cancel();
    emit(CountdownFinished());
    _countdownFinishedCallback?.call();
  }

  void setCallBack(VoidCallback callback) {
    _countdownFinishedCallback = callback;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
