import 'package:get_it/get_it.dart';
import 'package:marketplace/core/network/dio_client.dart';
import 'package:marketplace/data/repository/auth_repo_impl.dart';
import 'package:marketplace/data/repository/product_repo_impl.dart';
import 'package:marketplace/data/repository/secure_storage_repo_impl.dart';
import 'package:marketplace/data/source/auth_local_service_data_source.dart';
import 'package:marketplace/data/source/auth_service_data_source.dart';
import 'package:marketplace/data/source/products_service_data_source.dart';
import 'package:marketplace/domain/repository/auth_repo.dart';
import 'package:marketplace/domain/repository/products_repo.dart';
import 'package:marketplace/domain/repository/secure_storage_repo.dart';
import 'package:marketplace/domain/usecases/auth_usecase.dart';
import 'package:marketplace/domain/usecases/user_usecase.dart';
import 'package:marketplace/data/source/secure_storage_data_source.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());
  // data source
  sl.registerSingleton<AuthServiceDataSource>(AuthServiceImpl());
  sl.registerSingleton<SecureStorageDataSource>(SecureServiceImpl());
  sl.registerSingleton<AuthLocalServiceDataSource>(AuthLocalServiceImpl());
  sl.registerSingleton<ProductsServiceDataSource>(ProductServiceImpl());

  // repo
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SecureStorageRepository>(SecureStorageRepositoryImpl());
  sl.registerSingleton<ProductsRepository>(ProductRepositoryImpl());

  // usecases
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<LogInUseCase>(LogInUseCase());
  sl.registerSingleton<UserUsecase>(UserUsecase());
}
