import 'package:dartz/dartz.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/response_models.dart';


abstract class AuthRepository {
  Future<Either> signup(SignupParamsModel signUpParam);
  Future<Either> login(LoginParamsModel logInParam);
  Future<Either> refresh(String refreshToken);
  Future<Either> requestEmailVerificationOTP(String email);
  Future<Either> requestNewPasswordOTP(String email);
  Future<Either> resetPassword(ResetPasswordParams resetPasswordParams);
  Future<Either> getProfile();
  Future<Either> updateProfile(ProfileModel params);
  Future<Either> verifyEmailVerificationOTP(VerifyOtpParams verifyOtpParams);
}
