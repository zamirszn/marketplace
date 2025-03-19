part of 'account_verification_bloc.dart';

@immutable
sealed class AccountVerificationEvent {}

class EmailVerificationOTPCompleteEvent extends AccountVerificationEvent {
  final OTPComplete otpComplete;
  final int? otp;

  EmailVerificationOTPCompleteEvent(
      {required this.otpComplete, required this.otp});
}

final class ResendOTPEvent extends AccountVerificationEvent {
  final String? email;

  ResendOTPEvent({required this.email});
}

final class CanRequestEmailOTPEvent extends AccountVerificationEvent {}

final class SubmitEmailVerificationOTPEvent extends AccountVerificationEvent {
  final VerifyOtpParams params;

  SubmitEmailVerificationOTPEvent({required this.params});
}
