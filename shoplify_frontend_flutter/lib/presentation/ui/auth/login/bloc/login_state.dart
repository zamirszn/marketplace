part of 'login_bloc.dart';

@immutable
sealed class LoginState extends Equatable {
  @override
  List<Object?> get props => []; // Default empty props for base class
}

class LoginInitialState extends LoginState {
  final bool isUsernameValid;
  final bool isPasswordValid;
  final bool isPasswordVisible;

  LoginInitialState({
    this.isUsernameValid = true,
    this.isPasswordValid = true,
    this.isPasswordVisible = false,
  });

  @override
  List<Object?> get props =>
      [isUsernameValid, isPasswordValid, isPasswordVisible];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object?> get props => []; // No properties to compare, remains stateless
}

class LoginSuccessState extends LoginState {
  @override
  List<Object?> get props => []; // No properties to compare, remains stateless
}

class LoginFailureState extends LoginState {
  final String error;

  LoginFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

class LoginFormUpdateState extends LoginState {
  final bool isUsernameValid;
  final bool isPasswordValid;

  LoginFormUpdateState({
    required this.isUsernameValid,
    required this.isPasswordValid,
  });

  @override
  List<Object?> get props => [isUsernameValid, isPasswordValid];
}

class LoginTogglePasswordState extends LoginState {
  final bool isPasswordVisible;

  LoginTogglePasswordState({required this.isPasswordVisible});

  @override
  List<Object?> get props => [isPasswordVisible];
}
