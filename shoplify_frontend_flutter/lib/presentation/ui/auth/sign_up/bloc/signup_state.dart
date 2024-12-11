part of 'signup_bloc.dart';


@immutable
sealed class SignUpState extends Equatable {
  @override
  List<Object?> get props => []; // Default empty props for base class
}

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

  @override
  List<Object?> get props =>
      [isFullNameValid, isEmailValid, isPasswordValid, isPasswordVisible];
}

class SignUpLoadingState extends SignUpState {
  @override
  List<Object?> get props => []; // No properties to compare, remains stateless
}

class SignUpSuccessState extends SignUpState {
  @override
  List<Object?> get props => []; // No properties to compare, remains stateless
}

class SignUpFailureState extends SignUpState {
  final String error;

  SignUpFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

class SignUpTogglePasswordState extends SignUpState {
  final bool isPasswordVisible;

  SignUpTogglePasswordState({required this.isPasswordVisible});

  @override
  List<Object?> get props => [isPasswordVisible];
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

  @override
  List<Object?> get props => [isFullNameValid, isEmailValid, isPasswordValid];
}
