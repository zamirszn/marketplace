import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/add_to_cart_params_model.dart';
import 'package:marketplace/data/models/product_category_model.dart';
import 'package:marketplace/data/models/product_query_params_model.dart';
import 'package:marketplace/data/source/products_service_data_source.dart';
import 'package:marketplace/domain/repository/products_repo.dart';
import 'package:marketplace/presentation/service_locator.dart';

class ProductRepositoryImpl extends ProductsRepository {
  @override
  Future<Either> getProductCategories() async {
    Either result =
        await sl<ProductsServiceDataSource>().getProductCategories();
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> getNewProducts() async {
    Either result = await sl<ProductsServiceDataSource>().getNewProducts();
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> getPopularProducts() async {
    Either result = await sl<ProductsServiceDataSource>().getPopularProducts();
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> getAllProducts(ProductQueryParamsModel productParams) async {
    Either result =
        await sl<ProductsServiceDataSource>().getAllProducts(productParams);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  @override
  Future<Either> addToCart(AddToCartParamsModel addToCartParams) async {
    Either result =
        await sl<ProductsServiceDataSource>().addToCart(addToCartParams);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }

  String? _cartId;

  @override
  Future<String?> getCartId() async {
    return _cartId;
  }

  @override
  Future<Either> getOrCreateCart() async {
    Either result = await sl<ProductsServiceDataSource>().getOrCreateCart();
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      _cartId = response.data["id"];
      return Right(response.data);
    });
  }
}
