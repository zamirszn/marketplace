part of 'signup_bloc.dart';

@immutable
sealed class SignUpEvent {}

class SignUpFullNameChangedEvent extends SignUpEvent {
  final String fullName;
  SignUpFullNameChangedEvent(this.fullName);
}

class EmailChangedEvent extends SignUpEvent {
  final String email;
  EmailChangedEvent(this.email);
}

class SignUpPasswordChangedEvent extends SignUpEvent {
  final String password;
  SignUpPasswordChangedEvent(this.password);
}

class SignUpSubmittedEvent extends SignUpEvent {
  final SignupParamsModel params;

  SignUpSubmittedEvent({required this.params});
}

class SignUpPasswordVisibilityEvent extends SignUpEvent {
  final bool isPasswordVisible;

  SignUpPasswordVisibilityEvent({required this.isPasswordVisible});
}
