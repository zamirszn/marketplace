part of 'signup_bloc.dart';

enum SignUpStatus { initial, success, failure, loading }

class SignUpState extends Equatable {
  final bool isFullNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final String? errorMessage;
  final PasswordVisibility passwordVisibility;
  final SignUpStatus signUpStatus;

  const SignUpState({
    this.passwordVisibility = PasswordVisibility.off,
    this.signUpStatus = SignUpStatus.initial,
    this.isFullNameValid = false,
    this.isEmailValid = false,
    this.errorMessage,
    this.isPasswordValid = false,
  });

  @override
  List<Object?> get props => [
        isFullNameValid,
        isEmailValid,
        isPasswordValid,
        errorMessage,
        passwordVisibility,
        signUpStatus
      ];

  SignUpState copyWith({
    bool? isFullNameValid,
    bool? isEmailValid,
    bool? isPasswordValid,
    String? errorMessage,
    PasswordVisibility? passwordVisibility,
    SignUpStatus? signUpStatus,
  }) {
    return SignUpState(
      isFullNameValid: isFullNameValid ?? this.isFullNameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      errorMessage: errorMessage,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
      signUpStatus: signUpStatus ?? this.signUpStatus,
    );
  }
}
