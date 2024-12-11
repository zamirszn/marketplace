import 'package:dartz/dartz.dart';
import 'package:shoplify/core/usecase/usecase.dart';
import 'package:shoplify/data/models/login_params_model.dart';
import 'package:shoplify/data/models/signup_params_model.dart';
import 'package:shoplify/domain/repository/auth_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';

class SignupUseCase implements Usecase<Either, SignupParamsModel> {
  @override
  Future<Either> call({SignupParamsModel? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}

class LogInUseCase implements Usecase<Either, LoginParamsModel> {
  @override
  Future<Either> call({LoginParamsModel? params}) async {
    return sl<AuthRepository>().login(params!);
  }
}

class RefreshTokenUsecase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<AuthRepository>().refresh(params!);
  }
}
