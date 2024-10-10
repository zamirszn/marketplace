import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marketplace/data/models/signup_params_model.dart';
import 'package:marketplace/data/models/user_model.dart';
import 'package:marketplace/data/source/auth_local_service.dart';
import 'package:marketplace/data/source/auth_service.dart';
import 'package:marketplace/domain/entities/user_entity.dart';
import 'package:marketplace/domain/repository/auth_repo.dart';
import 'package:marketplace/presentation/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(SignupParamsModel signUpParam) async {
    Either result = await sl<AuthService>().signup(signUpParam);

    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response);
    });
  }

  @override
  Future<bool> isUserLoggedIn() {
    return sl.call<AuthLocalService>().isUserLoggedIn();
  }

  @override
  Future<Either> getUser() async {
    Either result = await sl<AuthService>().getUser();
    return result.fold((error) {
      return Left(error);
    }, (data) {
      Response response = data;
      final UserModel userModel = UserModel.fromMap(response.data);
      final UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    });
  }
}
