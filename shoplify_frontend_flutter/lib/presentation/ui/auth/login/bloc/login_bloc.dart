import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/models/login_params_model.dart';
import 'package:shoplify/domain/usecases/auth_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginEmailChangedEvent>(_onEmailChanged);
    on<LoginPasswordChangedEvent>(_onPasswordChanged);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LoginPasswordVisibileEvent>(_onTogglePasswordVisibility);
  }

  void _onTogglePasswordVisibility(
      LoginPasswordVisibileEvent event, Emitter<LoginState> emit) {
    if (event.isPasswordVisible == PasswordVisibility.on) {
      emit(state.copyWith(passwordVisibility: PasswordVisibility.off));
    } else {
      emit(state.copyWith(passwordVisibility: PasswordVisibility.on));
    }
  }

  void _onLoginSubmitted(
      LoginSubmittedEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(logInStatus: LoginStatus.loading));

    Either response = await sl<LogInUseCase>().call(params: event.params);
    response.fold((error) {
      emit(state.copyWith(
          logInStatus: LoginStatus.failure, errorMessage: error));
    }, (data) {
      // if account is blocked

      if (data[Constant.accountBlocked] == true) {
        emit(state.copyWith(logInStatus: LoginStatus.accountBlocked));
      }
      // if email is not verified

      else if (data[Constant.emailVerified] != true) {
        emit(state.copyWith(
            logInStatus: LoginStatus.unverified, email: data["email"]));
      }

      // if account is not blocked and verified continue to login
      else {
        emit(state.copyWith(
          logInStatus: LoginStatus.success,
        ));
      }
    });
  }

  void _onEmailChanged(LoginEmailChangedEvent event, Emitter<LoginState> emit) {
    final isEmailValid = validateEmail(event.email);

    emit(state.copyWith(isEmailValid: isEmailValid));
  }

  void _onPasswordChanged(
      LoginPasswordChangedEvent event, Emitter<LoginState> emit) {
    final isPasswordValid = validatePassword(event.password);

    emit(state.copyWith(isPasswordValid: isPasswordValid));
  }
}
