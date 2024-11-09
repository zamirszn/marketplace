import 'package:get_it/get_it.dart';
import 'package:marketplace/core/network/dio_client.dart';
import 'package:marketplace/data/repository/auth_repo_impl.dart';
import 'package:marketplace/data/repository/product_repo_impl.dart';
import 'package:marketplace/data/source/shared_pref_service_impl.dart';
import 'package:marketplace/data/source/auth_service_data_source.dart';
import 'package:marketplace/data/source/products_service_data_source.dart';
import 'package:marketplace/domain/repository/auth_repo.dart';
import 'package:marketplace/domain/repository/products_repo.dart';
import 'package:marketplace/domain/repository/secure_storage_repo.dart';
import 'package:marketplace/domain/usecases/auth_usecase.dart';
import 'package:marketplace/domain/usecases/products_usecase.dart';
import 'package:marketplace/domain/usecases/user_usecase.dart';
import 'package:marketplace/data/source/secure_storage_data_source.dart';

final sl = GetIt.instance;

void setupServiceLocator() async {
  sl.registerSingleton<DioClient>(DioClient());

  // data source
  sl.registerSingleton<AuthServiceDataSource>(AuthServiceImpl());
  sl.registerSingleton<SecureStorageDataSource>(SecureServiceImpl());
  sl.registerSingleton<SharedPrefDataSource>(SharePrefImpl());
  sl.registerSingleton<ProductsServiceDataSource>(ProductServiceImpl());

  // repo
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<ProductsRepository>(ProductRepositoryImpl());

  // usecases
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<LogInUseCase>(LogInUseCase());
  sl.registerSingleton<UserUsecase>(UserUsecase());
  sl.registerSingleton<GetProductCategoryUsecase>(GetProductCategoryUsecase());
  sl.registerSingleton<GetNewProductsUseCase>(GetNewProductsUseCase());
  sl.registerSingleton<GetPopularProductUseCase>(GetPopularProductUseCase());
  sl.registerSingleton<GetAllProductUseCase>(GetAllProductUseCase());
  sl.registerSingleton<AddToCartUseCase>(AddToCartUseCase());
  sl.registerSingleton<GetorCreateCartUseCase>(GetorCreateCartUseCase());
  sl.registerSingleton<GetCartIdUseCase>(GetCartIdUseCase());
  sl.registerSingleton<RefreshTokenUsecase>(RefreshTokenUsecase());

  final sharedPref = SharePrefImpl();
  await sharedPref.init();

  final secureStorage = SecureServiceImpl();
  await secureStorage.init();
}
