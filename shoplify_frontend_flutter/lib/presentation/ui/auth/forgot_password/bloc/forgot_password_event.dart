part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent {}

final class RequestForgotEvent extends ForgotPasswordEvent {
  final String email;
  final bool shouldRedirect;

  RequestForgotEvent({required this.email, required this.shouldRedirect});
}

final class ForgotPasswordVisibileEvent extends ForgotPasswordEvent {
  final PasswordVisibility isPasswordVisible;

  ForgotPasswordVisibileEvent({required this.isPasswordVisible});
}

class ResetPasswordOTPCompleteEvent extends ForgotPasswordEvent {
  final OTPComplete otpComplete;
  final int? otp;

  ResetPasswordOTPCompleteEvent({required this.otpComplete, required this.otp});
}

final class CanRequestPasswordOTPEvent extends ForgotPasswordEvent {}

final class SubmitNewPasswordOTPEvent extends ForgotPasswordEvent {
  final ResetPasswordParams resetPasswordParams;

  SubmitNewPasswordOTPEvent({required this.resetPasswordParams});
}
