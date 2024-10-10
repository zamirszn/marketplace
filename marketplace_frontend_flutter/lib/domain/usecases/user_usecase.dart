import 'package:dartz/dartz.dart';
import 'package:marketplace/core/usecase/usecase.dart';
import 'package:marketplace/domain/repository/auth_repo.dart';
import 'package:marketplace/presentation/service_locator.dart';

class UserUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return sl<AuthRepository>().getUser();
  }
}
