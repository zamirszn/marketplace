part of 'signup_bloc.dart';

@immutable
sealed class SignUpState {}

class SignUpInitial extends SignUpState {
  final bool isFullNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordVisible;

  SignUpInitial({
    this.isFullNameValid = true,
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.isPasswordVisible = false,
  });
}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure(this.error);
}

class SignUpTogglePassword extends SignUpState {
  final bool isPasswordVisible;

  SignUpTogglePassword({required this.isPasswordVisible});
}

class SignUpFormUpdate extends SignUpState {
  final bool isFullNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;

  SignUpFormUpdate({
    required this.isFullNameValid,
    required this.isEmailValid,
    required this.isPasswordValid,
  });
}
