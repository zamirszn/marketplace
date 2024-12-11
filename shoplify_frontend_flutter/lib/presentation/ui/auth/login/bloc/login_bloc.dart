import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/data/models/login_params_model.dart';
import 'package:shoplify/domain/usecases/auth_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginFullNameChangedEvent>(_onUsernameChanged);
    on<LoginPasswordChangedEvent>(_onPasswordChanged);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LoginPasswordVisibileEvent>(_onTogglePasswordVisibility);
  }

  void _onTogglePasswordVisibility(
      LoginPasswordVisibileEvent event, Emitter<LoginState> emit) {
    emit(LoginTogglePasswordState(isPasswordVisible: event.isPasswordVisible));
  }

  void _onLoginSubmitted(
      LoginSubmittedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());

    Either response = await sl<LogInUseCase>().call(params: event.params);
    response.fold((error) {
      emit(LoginFailureState(error));
    }, (data) {
      emit(LoginSuccessState());
    });
  }

  void _onUsernameChanged(
      LoginFullNameChangedEvent event, Emitter<LoginState> emit) {
    final isUsernameValid = validateUsername(event.fullName);
    final currentState = state;

    if (currentState is LoginInitialState ||
        currentState is LoginFormUpdateState) {
      emit(LoginFormUpdateState(
        isUsernameValid: isUsernameValid,
        isPasswordValid: (currentState is LoginFormUpdateState)
            ? currentState.isPasswordValid
            : true,
      ));
    }
  }

  void _onPasswordChanged(
      LoginPasswordChangedEvent event, Emitter<LoginState> emit) {
    final isPasswordValid = validatePassword(event.password);
    final currentState = state;

    if (currentState is LoginInitialState ||
        currentState is LoginFormUpdateState) {
      emit(LoginFormUpdateState(
        isUsernameValid: (currentState is LoginFormUpdateState)
            ? currentState.isUsernameValid
            : true,
        isPasswordValid: isPasswordValid,
      ));
    }
  }
}
