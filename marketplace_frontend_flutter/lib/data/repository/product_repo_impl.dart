import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/models/product_category_model.dart';
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
}
