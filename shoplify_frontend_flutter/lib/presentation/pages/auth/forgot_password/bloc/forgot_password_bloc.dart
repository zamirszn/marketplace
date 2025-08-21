import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/domain/usecases/auth_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<RequestForgotEvent>(_requestForgotPasswordOTP);
    on<ForgotPasswordVisibileEvent>(_onTogglePasswordVisibility);
    on<CanRequestPasswordOTPEvent>(_canRequestPasswordOTPAgainEvent);
    on<ResetPasswordOTPCompleteEvent>(_otpCompleteEvent);
    on<SubmitNewPasswordOTPEvent>(_submitNewPasswordEvent);
  }

  void _submitNewPasswordEvent(SubmitNewPasswordOTPEvent event,
      Emitter<ForgotPasswordState> emit) async {
    emit(state.copyWith(
      forgotPasswordStatus: ForgotPasswordStatus.submittingNewPassword,
    ));
    final Either response = await sl<ResetPasswordUsecase>()
        .call(params: event.resetPasswordParams);

    response.fold((error) {
      emit(state.copyWith(
          errorMessage: error,
          forgotPasswordStatus: ForgotPasswordStatus.failure,
          otpComplete: OTPComplete.incomplete));
    }, (data) {
      emit(state.copyWith(
        forgotPasswordStatus: ForgotPasswordStatus.success,
      ));
    });
  }

  void _canRequestPasswordOTPAgainEvent(
      CanRequestPasswordOTPEvent event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(
      isRequestingOTP: false,
      forgotPasswordStatus: ForgotPasswordStatus.initial,
    ));
  }

  void _otpCompleteEvent(
      ResetPasswordOTPCompleteEvent event, Emitter<ForgotPasswordState> emit) {
    if (event.otpComplete == OTPComplete.complete) {
      emit(state.copyWith(
        otpComplete: OTPComplete.complete,
        otpCode: event.otp,
        forgotPasswordStatus: ForgotPasswordStatus.initial,
      ));
    } else {
      emit(state.copyWith(
        otpComplete: OTPComplete.incomplete,
        forgotPasswordStatus: ForgotPasswordStatus.initial,
      ));
    }

  }

  void _onTogglePasswordVisibility(
      ForgotPasswordVisibileEvent event, Emitter<ForgotPasswordState> emit) {
    if (event.isPasswordVisible == PasswordVisibility.on) {
      emit(state.copyWith(
          forgotPasswordStatus: ForgotPasswordStatus.changingPassword,
          passwordVisibility: PasswordVisibility.off));
    } else {
      emit(state.copyWith(
        passwordVisibility: PasswordVisibility.on,
        forgotPasswordStatus: ForgotPasswordStatus.changingPassword,
      ));
    }
  }

  _requestForgotPasswordOTP(RequestForgotEvent event, Emitter emit) async {
    emit(state.copyWith(
        forgotPasswordStatus: ForgotPasswordStatus.requestingOTP,
        isRequestingOTP: true));

    final Either response =
        await sl<RequestNewPasswordOTPUsecase>().call(params: event.email);

    response.fold((error) {
      emit(state.copyWith(
          errorMessage: error,
          forgotPasswordStatus: ForgotPasswordStatus.failure));
    }, (data) {
      emit(state.copyWith(
          forgotPasswordStatus: event.shouldRedirect == true
              // bloclistener uses ForgotPasswordStatus.otpRequested to redirect to NewPasswordPage
              ? ForgotPasswordStatus.otpRequested
              : ForgotPasswordStatus.initial));
      state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.initial);
    });
  }
}
