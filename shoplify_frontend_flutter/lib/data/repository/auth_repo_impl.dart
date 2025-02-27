import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shoplify/data/models/login_params_model.dart';
import 'package:shoplify/data/models/reset_password_params.dart';
import 'package:shoplify/data/models/signup_params_model.dart';
import 'package:shoplify/data/models/user_model.dart';
import 'package:shoplify/data/models/verify_otp_params.dart';
import 'package:shoplify/data/source/auth_service_data_source.dart';
import 'package:shoplify/data/source/secure_storage_data_source.dart';
import 'package:shoplify/domain/entities/user_entity.dart';
import 'package:shoplify/domain/repository/auth_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';
import "package:shoplify/core/constants/constant.dart";
import 'package:shoplify/core/network/dio_client.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(SignupParamsModel signUpParam) async {
    Either result = await sl<AuthServiceDataSource>().signup(signUpParam);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response);
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
          .write(Constant.refreshToken, response.data[Constant.refreshToken]);
      await sl<SecureStorageDataSource>()
          .write(Constant.accessToken, response.data[Constant.accessToken]);

      return Right(response.data);
    });
  }

  @override
  Future<Either> getUser() async {
    Either result = await sl<AuthServiceDataSource>().getUser();
    return result.fold((error) {
      return Left(error);
    }, (data) {
      Response response = data;
      final UserModel userModel = UserModel.fromMap(response.data);
      final UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    });
  }

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
      return Right(response);
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
      return Right(response);
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
      return Right(response);
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
      return Right(response);
    });
  }
}
