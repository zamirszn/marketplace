import 'package:dartz/dartz.dart';
import 'package:marketplace/data/models/login_params_model.dart';
import 'package:marketplace/data/models/signup_params_model.dart';

abstract class AuthRepository {
  Future<Either> signup(SignupParamsModel signUpParam);
  Future<Either> login(LoginParamsModel logInParam);
  Future<Either> getUser();
}
