// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'forgot_password_bloc.dart';

enum ForgotPasswordStatus {
  initial,
  requestingOTP,
  otpRequested,
  changingPassword,
  submittingNewPassword,
  success,
  failure,
}

class ForgotPasswordState extends Equatable {
  final OTPComplete otpComplete;
  final ForgotPasswordStatus forgotPasswordStatus;
  final int? otpCode;
  final bool isRequestingOTP;
  final String? errorMessage;
  final PasswordVisibility passwordVisibility;

  const ForgotPasswordState(
      {this.otpComplete = OTPComplete.incomplete,
      this.forgotPasswordStatus = ForgotPasswordStatus.initial,
      this.otpCode,
      this.passwordVisibility = PasswordVisibility.off,
      this.isRequestingOTP = false,
      this.errorMessage});

  ForgotPasswordState copyWith({
    OTPComplete? otpComplete,
    ForgotPasswordStatus? forgotPasswordStatus,
    int? otpCode,
    bool? isRequestingOTP,
    String? errorMessage,
    PasswordVisibility? passwordVisibility,
  }) {
    return ForgotPasswordState(
      otpComplete: otpComplete ?? this.otpComplete,
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      otpCode: otpCode ?? otpCode,
      isRequestingOTP: isRequestingOTP ?? this.isRequestingOTP,
      errorMessage: errorMessage ?? errorMessage,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
    );
  }

  @override
  List<Object?> get props => [
        otpComplete,
        forgotPasswordStatus,
        otpCode,
        isRequestingOTP,
        passwordVisibility,
        errorMessage
      ];
}
