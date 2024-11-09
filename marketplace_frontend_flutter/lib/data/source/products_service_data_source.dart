import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marketplace/core/constants/api_urls.dart';
import 'package:marketplace/core/network/dio_client.dart';
import 'package:marketplace/data/models/add_to_cart_params_model.dart';
import 'package:marketplace/data/models/product_query_params_model.dart';
import 'package:marketplace/domain/usecases/products_usecase.dart';
import 'package:marketplace/presentation/service_locator.dart';

abstract class ProductsServiceDataSource {
  Future<Either> getProductCategories();
  Future<Either> getNewProducts();
  Future<Either> getPopularProducts();
  Future<Either> getAllProducts(ProductQueryParamsModel productParams);
  Future<Either> addToCart(AddToCartParamsModel addToCartParams);
  Future<Either> getOrCreateCart();
}

class ProductServiceImpl extends ProductsServiceDataSource {
  @override
  Future<Either> getProductCategories() async {
    try {
      Response response = await sl<DioClient>().get(ApiUrls.categories);
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> getNewProducts() async {
    try {
      Response response = await sl<DioClient>().get(ApiUrls.newProducts);
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> getPopularProducts() async {
    try {
      Response response = await sl<DioClient>().get(ApiUrls.popularProducts);
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> getAllProducts(ProductQueryParamsModel productParams) async {
    try {
      Response response = await sl<DioClient>()
          .get(ApiUrls.allProducts, queryParameters: productParams.toMap());
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> addToCart(AddToCartParamsModel addToCartParams) async {
    final cartId = await sl<GetCartIdUseCase>().call();
    try {
      Response response = await sl<DioClient>().post(
          "${ApiUrls.cartUrl}/$cartId/${ApiUrls.items}/",
          data: addToCartParams.toMap());
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> getOrCreateCart() async {
    try {
      Response response =
          await sl<DioClient>().post("${ApiUrls.cartUrl}/", data: {});
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }
}
