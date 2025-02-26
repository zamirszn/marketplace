part of 'signup_bloc.dart';

sealed class SignUpEvent {}

class SignUpFullNameChangedEvent extends SignUpEvent {
  final String fullName;
  SignUpFullNameChangedEvent(this.fullName);
}

class SignUpEmailChangedEvent extends SignUpEvent {
  final String email;
  SignUpEmailChangedEvent(this.email);
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
  final PasswordVisibility isPasswordVisible;

  SignUpPasswordVisibilityEvent({required this.isPasswordVisible});
}
