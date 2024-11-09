import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/data/models/signup_params_model.dart';
import 'package:marketplace/domain/usecases/auth_usecase.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpFullNameChangedEvent>(_onFullNameChanged);
    on<EmailChangedEvent>(_onEmailChanged);
    on<SignUpPasswordChangedEvent>(_onPasswordChanged);
    on<SignUpSubmittedEvent>(_onSignUpSubmitted);
    on<SignUpPasswordVisibilityEvent>(_onTogglePasswordVisibility);
  }

  void _onFullNameChanged(
      SignUpFullNameChangedEvent event, Emitter<SignUpState> emit) {
    final isFullNameValid = validateFullName(event.fullName);
    final currentState = state;

    if (currentState is SignUpInitialState ||
        currentState is SignUpFormUpdateState) {
      emit(SignUpFormUpdateState(
        isFullNameValid: isFullNameValid,
        isEmailValid: (currentState is SignUpFormUpdateState)
            ? currentState.isEmailValid
            : true,
        isPasswordValid: (currentState is SignUpFormUpdateState)
            ? currentState.isPasswordValid
            : true,
      ));
    }
  }

  void _onEmailChanged(EmailChangedEvent event, Emitter<SignUpState> emit) {
    final isEmailValid = validateEmail(event.email);
    final currentState = state;

    if (currentState is SignUpInitialState ||
        currentState is SignUpFormUpdateState) {
      emit(SignUpFormUpdateState(
        isFullNameValid: (currentState is SignUpFormUpdateState)
            ? currentState.isFullNameValid
            : true,
        isEmailValid: isEmailValid,
        isPasswordValid: (currentState is SignUpFormUpdateState)
            ? currentState.isPasswordValid
            : true,
      ));
    }
  }

  void _onPasswordChanged(
      SignUpPasswordChangedEvent event, Emitter<SignUpState> emit) {
    final isPasswordValid = validatePassword(event.password);
    final currentState = state;

    if (currentState is SignUpInitialState ||
        currentState is SignUpFormUpdateState) {
      emit(SignUpFormUpdateState(
        isFullNameValid: (currentState is SignUpFormUpdateState)
            ? currentState.isFullNameValid
            : true,
        isEmailValid: (currentState is SignUpFormUpdateState)
            ? currentState.isEmailValid
            : true,
        isPasswordValid: isPasswordValid,
      ));
    }
  }

  void _onSignUpSubmitted(
      SignUpSubmittedEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());

    Either response = await sl<SignupUseCase>().call(params: event.params);

    response.fold((error) {
      emit(SignUpFailureState(error));
    }, (data) {
      emit(SignUpSuccessState());
    });
  }

  void _onTogglePasswordVisibility(
      SignUpPasswordVisibilityEvent event, Emitter<SignUpState> emit) {
    emit(SignUpTogglePasswordState(isPasswordVisible: event.isPasswordVisible));
  }
}
