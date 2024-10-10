import 'package:get_it/get_it.dart';
import 'package:marketplace/core/network/dio_client.dart';
import 'package:marketplace/data/repository/auth_repo_impl.dart';
import 'package:marketplace/data/source/auth_local_service.dart';
import 'package:marketplace/data/source/auth_service.dart';
import 'package:marketplace/domain/repository/auth_repo.dart';
import 'package:marketplace/domain/usecases/signup_usecase.dart';
import 'package:marketplace/domain/usecases/user_usecase.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerSingleton<AuthService>(AuthServiceImpl());
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());
  sl.registerSingleton<UserUsecase>(UserUsecase());
}
