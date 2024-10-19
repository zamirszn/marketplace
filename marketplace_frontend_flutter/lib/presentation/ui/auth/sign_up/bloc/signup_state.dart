part of 'signup_bloc.dart';

@immutable
sealed class SignUpState {}

class SignUpInitialState extends SignUpState {
  final bool isFullNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordVisible;

  SignUpInitialState({
    this.isFullNameValid = true,
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.isPasswordVisible = false,
  });
}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {}

class SignUpFailureState extends SignUpState {
  final String error;
  SignUpFailureState(this.error);
}

class SignUpTogglePasswordState extends SignUpState {
  final bool isPasswordVisible;

  SignUpTogglePasswordState({required this.isPasswordVisible});
}

class SignUpFormUpdateState extends SignUpState {
  final bool isFullNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;

  SignUpFormUpdateState({
    required this.isFullNameValid,
    required this.isEmailValid,
    required this.isPasswordValid,
  });
}
