import 'package:dartz/dartz.dart';
import 'package:marketplace/core/usecase/usecase.dart';
import 'package:marketplace/data/models/signup_params_model.dart';
import 'package:marketplace/domain/repository/auth_repo.dart';
import 'package:marketplace/presentation/service_locator.dart';

class SignupUseCase implements Usecase<Either, SignupParamsModel> {
  @override
  Future<Either> call({SignupParamsModel? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}

class IsLoggedInUseCase implements Usecase<bool, dynamic> {
  @override
  Future<bool> call({dynamic params}) async {
    return sl<AuthRepository>().isUserLoggedIn();
  }
}
