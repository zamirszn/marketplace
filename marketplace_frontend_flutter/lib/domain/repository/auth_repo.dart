import 'package:dartz/dartz.dart';
import 'package:marketplace/data/models/signup_params_model.dart';

abstract class AuthRepository {
  Future<Either> signup(SignupParamsModel signUpParam);
  Future<bool> isUserLoggedIn();
  Future<Either> getUser();
}
