import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marketplace/core/constants/api_urls.dart';
import 'package:marketplace/core/network/dio_client.dart';
import 'package:marketplace/data/models/signup_params_model.dart';
import 'package:marketplace/presentation/service_locator.dart';

abstract class AuthService {
  Future<Either> signup(SignupParamsModel signUpParam);
  Future<Either> getUser();
}

class AuthServiceImpl extends AuthService {
  @override
  Future<Either> signup(SignupParamsModel signUpParam) async {
    try {
      final response = await sl<DioClient>()
          .post(ApiUrls.register, data: signUpParam.toMap());

      return Right(response);
    } on DioException catch (e) {
      return Left(e.response?.data["message"]);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrls.userProfile,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response?.data["message"]);
    }
  }
}
