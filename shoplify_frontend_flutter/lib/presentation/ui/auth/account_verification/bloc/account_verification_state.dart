// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'account_verification_bloc.dart';

/// this switches the `AccountVerificationPage` background color
/// based on the OTP code entered, if a complete code or valid code is entered
/// the background color changes to green , if an invalid or incomplete code is
/// entered it changes to red

enum VerificationStatus {
  initial,
  loading,
  success,
  failure,
}

class AccountVerificationState extends Equatable {
  final OTPComplete otpComplete;
  final VerificationStatus verificationStatus;
  final int? otpCode;
  final bool isRequestingOTP;
  final String? errorMessage;

  const AccountVerificationState(
      {this.verificationStatus = VerificationStatus.initial,
      this.otpComplete = OTPComplete.incomplete,
      this.otpCode,
      this.isRequestingOTP = false,
      this.errorMessage});

  @override
  List<Object?> get props =>
      [otpComplete, verificationStatus, otpCode, isRequestingOTP, errorMessage];

  AccountVerificationState copyWith(
      {OTPComplete? otpComplete,
      VerificationStatus? verificationStatus,
      int? otpCode,
      bool? isRequestingOTP,
      String? errorMessage}) {
    return AccountVerificationState(
      otpComplete: otpComplete ?? this.otpComplete,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      otpCode: otpCode ?? otpCode,
      errorMessage: errorMessage ?? errorMessage,
      isRequestingOTP: isRequestingOTP ?? this.isRequestingOTP,
    );
  }
}
