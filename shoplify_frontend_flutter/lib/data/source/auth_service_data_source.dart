import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/core/network/dio_client.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/response_models.dart';
import 'package:shoplify/presentation/service_locator.dart';

abstract class AuthServiceDataSource {
  Future<Either> signup(SignupParamsModel signUpParam);
  Future<Either> login(LoginParamsModel logInParam);
  Future<Either> refresh(String token);
  Future<Either> requestEmailVerificationOTP(String email);
  Future<Either> requestNewPasswordOTP(String email);
  Future<Either> resetPassword(ResetPasswordParams resetPasswordParams);
  Future<Either> verifyEmailVerificationOTP(VerifyOtpParams verifyParams);
  Future<Either> getProfile();
  Future<Either> updateProfile(ProfileModel params);
}

class AuthServiceImpl extends AuthServiceDataSource {
  @override
  Future<Either> signup(SignupParamsModel signUpParam) async {
    try {
      final response = await sl<DioClient>()
          .post(ApiUrls.register, data: signUpParam.toMap());
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> login(LoginParamsModel logInParam) async {
    try {
      final response =
          await sl<DioClient>().post(ApiUrls.login, data: logInParam.toMap());
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> refresh(String token) async {
    try {
      final response = await sl<DioClient>().post(ApiUrls.refreshToken, data: {
        "refresh": token,
      });
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> requestEmailVerificationOTP(String email) async {
    try {
      final response = await sl<DioClient>()
          .post(ApiUrls.requestEmailActivationOTP, data: {"email": email});
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> verifyEmailVerificationOTP(
      VerifyOtpParams verifyParams) async {
    try {
      final response = await sl<DioClient>()
          .post(ApiUrls.verifyEmail, data: verifyParams.toMap());
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> requestNewPasswordOTP(String email) async {
    try {
      final response = await sl<DioClient>()
          .post(ApiUrls.requestNewPasswordOTP, data: {"email": email});
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> resetPassword(ResetPasswordParams resetPasswordParams) async {
    try {
      final response = await sl<DioClient>()
          .post(ApiUrls.resetPassword, data: resetPasswordParams.toMap());
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> getProfile() async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.profile,
      );
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> updateProfile(ProfileModel params) async {
    try {
      final Map<String, dynamic> p = params.toMap();
      p.removeWhere((key, value) {
        if (key == "profilePicture") {
          return true;
        }
        return false;
      });

      Map<String, dynamic> formDataMap = Map.from(p);

      if (params.profilePicture != null) {
        formDataMap['profilePicture'] =
            await MultipartFile.fromFile(params.profilePicture);
      }

      final formData = FormData.fromMap(formDataMap);

      final response =
          await sl<DioClient>().patch(ApiUrls.profile, data: formData);
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }
}
