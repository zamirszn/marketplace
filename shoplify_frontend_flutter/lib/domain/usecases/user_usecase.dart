import 'package:dartz/dartz.dart';
import 'package:shoplify/core/usecase/usecase.dart';
import 'package:shoplify/domain/repository/auth_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';

class UserUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return sl<AuthRepository>().getUser();
  }
}
