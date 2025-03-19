part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginEmailChangedEvent extends LoginEvent {
  final String email;
  LoginEmailChangedEvent(this.email);
}

class LoginPasswordChangedEvent extends LoginEvent {
  final String password;
  LoginPasswordChangedEvent(this.password);
}

class LoginSubmittedEvent extends LoginEvent {
  final LoginParamsModel params;

  LoginSubmittedEvent({required this.params});
}

class LoginPasswordVisibileEvent extends LoginEvent {
  final PasswordVisibility isPasswordVisible;

  LoginPasswordVisibileEvent({required this.isPasswordVisible});
}
