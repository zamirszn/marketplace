import 'package:dartz/dartz.dart';
import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/core/network/dio_client.dart';
import 'package:shoplify/data/models/login_params_model.dart';
import 'package:shoplify/data/models/signup_params_model.dart';
import 'package:shoplify/presentation/service_locator.dart';

abstract class AuthServiceDataSource {
  Future<Either> signup(SignupParamsModel signUpParam);
  Future<Either> login(LoginParamsModel logInParam);
  Future<Either> getUser();
  Future<Either> refresh(String token);
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
  Future<Either> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
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
}
