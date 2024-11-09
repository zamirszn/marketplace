import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marketplace/data/models/login_params_model.dart';
import 'package:marketplace/data/models/signup_params_model.dart';
import 'package:marketplace/data/models/user_model.dart';
import 'package:marketplace/data/source/auth_service_data_source.dart';
import 'package:marketplace/data/source/secure_storage_data_source.dart';
import 'package:marketplace/domain/entities/user_entity.dart';
import 'package:marketplace/domain/repository/auth_repo.dart';
import 'package:marketplace/presentation/service_locator.dart';
import "package:marketplace/core/constants/constant.dart";
import 'package:marketplace/core/network/dio_client.dart';

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

      sl<DioClient>().setAuthToken(response.data[Constant.accessToken]);
      await sl<SecureStorageDataSource>()
          .write(Constant.refreshToken, response.data[Constant.refreshToken]);
      await sl<SecureStorageDataSource>()
          .write(Constant.accessToken, response.data[Constant.accessToken]);

      


      return const Right(null);
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
  Future<Either> refresh(String token) async {
    Either result = await sl<AuthServiceDataSource>().refresh(token);

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
}
