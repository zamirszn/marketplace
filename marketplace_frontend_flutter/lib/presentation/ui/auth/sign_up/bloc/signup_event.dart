part of 'signup_bloc.dart';

@immutable
sealed class SignUpEvent {}

class FullNameChanged extends SignUpEvent {
  final String fullName;
  FullNameChanged(this.fullName);
}

class EmailChanged extends SignUpEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends SignUpEvent {
  final String password;
  PasswordChanged(this.password);
}

class SignUpSubmitted extends SignUpEvent {
  final SignupParamsModel params;

  SignUpSubmitted({required this.params});
}

class TogglePasswordVisibility extends SignUpEvent {
  final bool isPasswordVisible;

  TogglePasswordVisibility({required this.isPasswordVisible});
}
