import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shoplify/core/constants/constant.dart';
import 'package:shoplify/core/network/dio_client.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/source/secure_storage_data_source.dart';
import 'package:shoplify/domain/usecases/auth_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

part 'account_verification_event.dart';
part 'account_verification_state.dart';

class AccountVerificationBloc
    extends Bloc<AccountVerificationEvent, AccountVerificationState> {
  AccountVerificationBloc() : super(const AccountVerificationState()) {
    on<EmailVerificationOTPCompleteEvent>(_otpCompleteEvent);
    on<ResendOTPEvent>(_requestOTPEvent);
    on<CanRequestEmailOTPEvent>(_canRequestEmailOTPAgainEvent);
    on<SubmitEmailVerificationOTPEvent>(_submitOTPEvent);
  }

  void _submitOTPEvent(SubmitEmailVerificationOTPEvent event,
      Emitter<AccountVerificationState> emit) async {
    emit(
      state.copyWith(verificationStatus: VerificationStatus.loading),
    );

    final Either response =
        await sl<VerifyEmailOTPUsecase>().call(params: event.params);
    response.fold((error) {
      emit(state.copyWith(
        errorMessage: error,
        verificationStatus: VerificationStatus.failure,
        otpComplete: OTPComplete.incomplete,
      ));
    }, (data) async {
      Response response = data;
      sl<DioClient>().setAuthToken(response.data[Constant.accessToken]);
      sl<SecureStorageDataSource>()
          .write(Constant.accessToken, response.data[Constant.accessToken]);
      emit(state.copyWith(
          errorMessage: null,
          isRequestingOTP: false,
          otpCode: null,
          otpComplete: OTPComplete.complete,
          verificationStatus: VerificationStatus.success));
    });
  }

  void _requestOTPEvent(
      ResendOTPEvent event, Emitter<AccountVerificationState> emit) async {
    emit(state.copyWith(
        isRequestingOTP: true, otpComplete: OTPComplete.incomplete));
    Either response = await sl<RequestEmailVerificationOTPUsecase>()
        .call(params: event.email);
    response.fold((error) {
      emit(state.copyWith(
          verificationStatus: VerificationStatus.failure,
          otpComplete: OTPComplete.incomplete,
          errorMessage: error));
    }, (data) {
      // do nothing if otp is requested
    });
  }

  void _canRequestEmailOTPAgainEvent(
      CanRequestEmailOTPEvent event, Emitter<AccountVerificationState> emit) {
    emit(state.copyWith(
      isRequestingOTP: false,
    ));
  }

  void _otpCompleteEvent(EmailVerificationOTPCompleteEvent event,
      Emitter<AccountVerificationState> emit) {
    if (event.otpComplete == OTPComplete.complete) {
      emit(state.copyWith(
          otpComplete: OTPComplete.complete, otpCode: event.otp));
    } else {
      emit(state.copyWith(otpComplete: OTPComplete.incomplete));
    }
  }
}
