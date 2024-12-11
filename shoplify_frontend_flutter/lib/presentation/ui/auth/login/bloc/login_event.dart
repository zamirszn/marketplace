part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginFullNameChangedEvent extends LoginEvent {
  final String fullName;
  LoginFullNameChangedEvent(this.fullName);
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
  final bool isPasswordVisible;

  LoginPasswordVisibileEvent({required this.isPasswordVisible});
}
