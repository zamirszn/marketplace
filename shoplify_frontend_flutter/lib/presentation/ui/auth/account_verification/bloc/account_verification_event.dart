part of 'account_verification_bloc.dart';

@immutable
sealed class AccountVerificationEvent {}

class OTPCompleteEvent extends AccountVerificationEvent {
  final OTPComplete otpComplete;
  final int otp;

  OTPCompleteEvent({required this.otpComplete, required this.otp});
}

final class ResendOTPEvent extends AccountVerificationEvent {
  final String? email;

  ResendOTPEvent({required this.email});
}

final class CanRequestOTPEvent extends AccountVerificationEvent {}

final class SubmitOTPEvent extends AccountVerificationEvent {
  final VerifyOtpParams params;

  SubmitOTPEvent({required this.params});
}
