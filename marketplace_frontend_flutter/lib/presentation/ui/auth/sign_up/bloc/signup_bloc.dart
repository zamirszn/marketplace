import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/app/functions.dart';
import 'package:marketplace/core/usecase/usecase.dart';
import 'package:marketplace/data/models/signup_params_model.dart';
import 'package:marketplace/domain/usecases/signup_usecase.dart';
import 'package:marketplace/presentation/service_locator.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<FullNameChanged>(_onFullNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  void _onFullNameChanged(FullNameChanged event, Emitter<SignUpState> emit) {
    final isFullNameValid = validateFullName(event.fullName);
    final currentState = state;

    if (currentState is SignUpInitial || currentState is SignUpFormUpdate) {
      emit(SignUpFormUpdate(
        isFullNameValid: isFullNameValid,
        isEmailValid: (currentState is SignUpFormUpdate)
            ? currentState.isEmailValid
            : true,
        isPasswordValid: (currentState is SignUpFormUpdate)
            ? currentState.isPasswordValid
            : true,
      ));
    }
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignUpState> emit) {
    final isEmailValid = validateEmail(event.email);
    final currentState = state;

    if (currentState is SignUpInitial || currentState is SignUpFormUpdate) {
      emit(SignUpFormUpdate(
        isFullNameValid: (currentState is SignUpFormUpdate)
            ? currentState.isFullNameValid
            : true,
        isEmailValid: isEmailValid,
        isPasswordValid: (currentState is SignUpFormUpdate)
            ? currentState.isPasswordValid
            : true,
      ));
    }
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignUpState> emit) {
    final isPasswordValid = validatePassword(event.password);
    final currentState = state;

    if (currentState is SignUpInitial || currentState is SignUpFormUpdate) {
      emit(SignUpFormUpdate(
        isFullNameValid: (currentState is SignUpFormUpdate)
            ? currentState.isFullNameValid
            : true,
        isEmailValid: (currentState is SignUpFormUpdate)
            ? currentState.isEmailValid
            : true,
        isPasswordValid: isPasswordValid,
      ));
    }
  }

  void _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    // Simulating a sign-up process
    Either response = await sl<SignupUseCase>().call(params: event.params);

    response.fold((error) {
      emit(SignUpFailure(error));
    }, (data) {
      emit(SignUpSuccess());
    });
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibility event, Emitter<SignUpState> emit) {
    emit(SignUpTogglePassword(isPasswordVisible: !event.isPasswordVisible));
  }
}
