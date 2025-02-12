import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/core/network/dio_client.dart';
import 'package:shoplify/data/models/add_to_cart_params_model.dart';
import 'package:shoplify/data/models/product_query_params_model.dart';
import 'package:shoplify/domain/usecases/products_usecase.dart';
import 'package:shoplify/presentation/service_locator.dart';

abstract class ProductsServiceDataSource {
  Future<Either> getProductCategories();
  Future<Either> getNewProducts();
  Future<Either> getPopularProducts();
  Future<Either> getAllProducts(ProductQueryParamsModel productParams);
  Future<Either> addToCart(AddToCartParamsModel addToCartParams);
  Future<Either> getOrCreateCart();
  Future<Either> addToFavorite(String productId);
  Future<Either> removeToFavorite(String productId);
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
  Future<Either> addToFavorite(String productId) async {
    try {
      Response response = await sl<DioClient>()
          .post("${ApiUrls.favorites}/add/$productId", data: {});
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }
  @override
  Future<Either> removeToFavorite(String productId) async {
    try {
      Response response = await sl<DioClient>()
          .delete("${ApiUrls.favorites}/remove/$productId", data: {});
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
