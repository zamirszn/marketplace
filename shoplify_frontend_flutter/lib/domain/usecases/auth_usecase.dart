import 'package:dartz/dartz.dart';
import 'package:shoplify/core/usecase/usecase.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/domain/repository/auth_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';

class SignupUseCase implements Usecase<Either, SignupParamsModel> {
  @override
  Future<Either> call({SignupParamsModel? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}

class LogInUseCase implements Usecase<Either, LoginParamsModel> {
  @override
  Future<Either> call({LoginParamsModel? params}) async {
    return sl<AuthRepository>().login(params!);
  }
}

class RefreshTokenUsecase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<AuthRepository>().refresh(params!);
  }
}

class RequestEmailVerificationOTPUsecase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<AuthRepository>().requestEmailVerificationOTP(params!);
  }
}

class VerifyEmailOTPUsecase implements Usecase<Either, VerifyOtpParams> {
  @override
  Future<Either> call({VerifyOtpParams? params}) async {
    return sl<AuthRepository>().verifyEmailVerificationOTP(params!);
  }
}

class RequestNewPasswordOTPUsecase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<AuthRepository>().requestNewPasswordOTP(params!);
  }
}

class ResetPasswordUsecase implements Usecase<Either, ResetPasswordParams> {
  @override
  Future<Either> call({ResetPasswordParams? params}) async {
    return sl<AuthRepository>().resetPassword(params!);
  }
}
class GetProfileUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return sl<AuthRepository>().getProfile();
  }
}


