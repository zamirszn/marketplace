import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import "package:shoplify/core/constants/constant.dart";
import 'package:shoplify/core/network/dio_client.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/response_models.dart';
import 'package:shoplify/data/source/auth_service_data_source.dart';
import 'package:shoplify/data/source/secure_storage_data_source.dart';
import 'package:shoplify/domain/repository/auth_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(SignupParamsModel signUpParam) async {
    Either result = await sl<AuthServiceDataSource>().signup(signUpParam);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> login(LoginParamsModel logInParam) async {
    Either result = await sl<AuthServiceDataSource>().login(logInParam);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      // email verification and account block check
      if (response.data[Constant.success] == false) {
        return Right(response.data);
      }

      // if account isnt blocked and email is verified
      // save token

      sl<DioClient>().setAuthToken(response.data[Constant.accessToken]);

      await sl<SecureStorageDataSource>()
          .write(Constant.accessToken, response.data[Constant.accessToken]);

      return Right(response.data);
    });
  }

  // TODO: remove
  @override
  Future<Either> refresh(String refreshToken) async {
    Either result = await sl<AuthServiceDataSource>().refresh(refreshToken);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;

      sl<DioClient>().setAuthToken(response.data[Constant.accessToken]);
      await sl<SecureStorageDataSource>()
          .write(Constant.accessToken, response.data[Constant.accessToken]);

      return Right(response.data);
    });
  }

  @override
  Future<Either> requestEmailVerificationOTP(String email) async {
    Either result =
        await sl<AuthServiceDataSource>().requestEmailVerificationOTP(email);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> verifyEmailVerificationOTP(
      VerifyOtpParams verifyOtpParams) async {
    Either result = await sl<AuthServiceDataSource>()
        .verifyEmailVerificationOTP(verifyOtpParams);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> requestNewPasswordOTP(String email) async {
    Either result =
        await sl<AuthServiceDataSource>().requestNewPasswordOTP(email);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> resetPassword(ResetPasswordParams resetPasswordParams) async {
    Either result =
        await sl<AuthServiceDataSource>().resetPassword(resetPasswordParams);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> getProfile() async {
    Either result = await sl<AuthServiceDataSource>().getProfile();
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> updateProfile(ProfileModel params) async{
    Either result = await sl<AuthServiceDataSource>().updateProfile(params);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }
}
