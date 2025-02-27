import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoplify/app/functions.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/models/signup_params_model.dart';
import 'package:shoplify/domain/usecases/auth_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<SignUpFullNameChangedEvent>(_onFullNameChanged);
    on<SignUpEmailChangedEvent>(_onEmailChanged);
    on<SignUpPasswordChangedEvent>(_onPasswordChanged);
    on<SignUpSubmittedEvent>(_onSignUpSubmitted);
    on<SignUpPasswordVisibilityEvent>(_onTogglePasswordVisibility);
  }

  void _onFullNameChanged(
      SignUpFullNameChangedEvent event, Emitter<SignUpState> emit) {
    final isFullNameValid = validateFullName(event.fullName);

    emit(state.copyWith(
      isFullNameValid: isFullNameValid,
    ));
  }

  void _onEmailChanged(
      SignUpEmailChangedEvent event, Emitter<SignUpState> emit) {
    final isEmailValid = validateEmail(event.email);

    emit(state.copyWith(
      isEmailValid: isEmailValid,
    ));
  }

  void _onPasswordChanged(
      SignUpPasswordChangedEvent event, Emitter<SignUpState> emit) {
    final isPasswordValid = validatePassword(event.password);

    emit(state.copyWith(
      isPasswordValid: isPasswordValid,
    ));
  }

  void _onSignUpSubmitted(
      SignUpSubmittedEvent event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(
      signUpStatus: SignUpStatus.loading,
    ));

    Either response = await sl<SignupUseCase>().call(params: event.params);

    response.fold((error) {
      emit(state.copyWith(
          signUpStatus: SignUpStatus.failure, errorMessage: error));
    }, (data) {
      emit(state.copyWith(
        signUpStatus: SignUpStatus.success,
      ));
    });
  }

  void _onTogglePasswordVisibility(
      SignUpPasswordVisibilityEvent event, Emitter<SignUpState> emit) {
    if (event.isPasswordVisible == PasswordVisibility.on) {
      emit(state.copyWith(
        passwordVisibility: PasswordVisibility.off,
      ));
    } else {
      emit(state.copyWith(
        passwordVisibility: PasswordVisibility.on,
      ));
    }
  }
}
