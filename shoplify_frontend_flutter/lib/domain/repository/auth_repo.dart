import 'package:dartz/dartz.dart';
import 'package:shoplify/data/models/login_params_model.dart';
import 'package:shoplify/data/models/signup_params_model.dart';
import 'package:shoplify/data/models/verify_otp_params.dart';

abstract class AuthRepository {
  Future<Either> signup(SignupParamsModel signUpParam);
  Future<Either> login(LoginParamsModel logInParam);
  Future<Either> getUser();
  Future<Either> refresh(String refreshToken);
  Future<Either> requestOTP(String email);
  Future<Either> verifyOTP(VerifyOtpParams verifyOtpParams);
}
