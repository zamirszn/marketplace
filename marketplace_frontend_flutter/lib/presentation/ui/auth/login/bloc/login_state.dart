part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

class LoginInitialState extends LoginState {
  final bool isUsernameValid;
  final bool isPasswordValid;
  final bool isPasswordVisible;

  LoginInitialState({
    this.isUsernameValid = true,
    this.isPasswordValid = true,
    this.isPasswordVisible = false,
  });
}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailureState extends LoginState {
  final String error;
  LoginFailureState(this.error);
}

class LoginFormUpdateState extends LoginState {
  final bool isUsernameValid;
  final bool isPasswordValid;

  LoginFormUpdateState(
      {required this.isUsernameValid,
      required this.isPasswordValid,
  });
}

class LoginTogglePasswordState extends LoginState {
  final bool isPasswordVisible;

  LoginTogglePasswordState({required this.isPasswordVisible});
}
