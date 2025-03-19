// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  success,
  failure,
  loading,
  accountBlocked,
  unverified
}

class LoginState extends Equatable {
  final bool isEmailValid;
  final bool isPasswordValid;
  final String? errorMessage;
  final PasswordVisibility passwordVisibility;
  final LoginStatus logInStatus;
  final String? email;

  const LoginState(
      {this.isEmailValid = false,
      this.isPasswordValid = false,
      this.errorMessage,
      this.passwordVisibility = PasswordVisibility.off,
      this.logInStatus = LoginStatus.initial,
      this.email});

  @override
  List<Object?> get props => [
        isEmailValid,
        isPasswordValid,
        errorMessage,
        passwordVisibility,
        logInStatus,
        email
      ];

  LoginState copyWith(
      {bool? isEmailValid,
      bool? isPasswordValid,
      String? errorMessage,
      PasswordVisibility? passwordVisibility,
      LoginStatus? logInStatus,
      String? email}) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      errorMessage: errorMessage,
      email: email,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      logInStatus: logInStatus ?? this.logInStatus,
    );
  }
}
