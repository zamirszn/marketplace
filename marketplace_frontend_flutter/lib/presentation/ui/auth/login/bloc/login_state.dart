part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

class LoginInitial extends LoginState {
  final bool isUsernameValid;
  final bool isPasswordValid;
  final bool isPasswordVisible;

  LoginInitial(
      {this.isUsernameValid = true,
      this.isPasswordValid = true,
      this.isPasswordVisible = false});
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LoginFormUpdate extends LoginState {
  final bool isUsernameValid;
  final bool isPasswordValid;
  final bool isPasswordVisible; // Add this line

  LoginFormUpdate(
      {required this.isUsernameValid,
      required this.isPasswordValid,
      required this.isPasswordVisible}); // Update constructor
}
