import 'package:get_it/get_it.dart';
import 'package:shoplify/core/network/dio_client.dart';
import 'package:shoplify/data/repository/auth_repo_impl.dart';
import 'package:shoplify/data/repository/product_repo_impl.dart';
import 'package:shoplify/data/repository/review_repo_impl.dart';
import 'package:shoplify/data/source/review_service_data_source.dart';
import 'package:shoplify/data/source/shared_pref_service_impl.dart';
import 'package:shoplify/data/source/auth_service_data_source.dart';
import 'package:shoplify/data/source/products_service_data_source.dart';
import 'package:shoplify/domain/repository/auth_repo.dart';
import 'package:shoplify/domain/repository/products_repo.dart';
import 'package:shoplify/domain/repository/review_repo.dart';
import 'package:shoplify/domain/usecases/auth_usecase.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/data/source/secure_storage_data_source.dart';

final sl = GetIt.instance;

void setupServiceLocator() async {
  sl.registerSingleton<DioClient>(DioClient());

  // data source
  sl.registerSingleton<AuthServiceDataSource>(AuthServiceImpl());
  sl.registerSingleton<SecureStorageDataSource>(SecureServiceImpl());
  sl.registerSingleton<SharedPrefDataSource>(SharePrefImpl());
  sl.registerSingleton<ProductsServiceDataSource>(ProductServiceImpl());
  sl.registerSingleton<ReviewServiceDataSource>(ReviewServiceDataSourceImpl());
  

  // repo
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<ProductsRepository>(ProductRepositoryImpl());
  sl.registerSingleton<ReviewRepository>(ReviewRepositoryImpl());

  // auth usecases
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<LogInUseCase>(LogInUseCase());
  // sl.registerSingleton<UserUsecase>(UserUsecase());
  sl.registerSingleton<RefreshTokenUsecase>(RefreshTokenUsecase());
  sl.registerSingleton<RequestEmailVerificationOTPUsecase>(
      RequestEmailVerificationOTPUsecase());
  sl.registerSingleton<VerifyEmailOTPUsecase>(VerifyEmailOTPUsecase());
  sl.registerSingleton<RequestNewPasswordOTPUsecase>(
      RequestNewPasswordOTPUsecase());
  sl.registerSingleton<ResetPasswordUsecase>(
      ResetPasswordUsecase());
  sl.registerSingleton<GetProfileUseCase>(
      GetProfileUseCase());

  //product usecases
  sl.registerSingleton<GetProductCategoryUsecase>(GetProductCategoryUsecase());
  sl.registerSingleton<GetNewProductsUseCase>(GetNewProductsUseCase());
  sl.registerSingleton<GetPopularProductUseCase>(GetPopularProductUseCase());
  sl.registerSingleton<GetAllProductUseCase>(GetAllProductUseCase());
  sl.registerSingleton<AddToCartUseCase>(AddToCartUseCase());
  sl.registerSingleton<GetorCreateCartUseCase>(GetorCreateCartUseCase());
  sl.registerSingleton<GetCartIdUseCase>(GetCartIdUseCase());
  sl.registerSingleton<AddtoFavoriteUseCase>(AddtoFavoriteUseCase());
  sl.registerSingleton<RemovefromFavoriteUseCase>(RemovefromFavoriteUseCase());
  sl.registerSingleton<RefreshProductDetails>(RefreshProductDetails());
  sl.registerSingleton<SearchProductUseCase>(SearchProductUseCase());

  // cart
  sl.registerSingleton<RemoveFromCartUseCase>(RemoveFromCartUseCase());


  // review usecase
  sl.registerSingleton<GetReviewsUseCase>(GetReviewsUseCase());
  sl.registerSingleton<SubmitReviewUsecase>(SubmitReviewUsecase());

  // favorite
  sl.registerSingleton<GetFavoriteProductUseCase>(GetFavoriteProductUseCase());
  
  // order
  sl.registerSingleton<GetMyOrderUseCase>(GetMyOrderUseCase());
}
