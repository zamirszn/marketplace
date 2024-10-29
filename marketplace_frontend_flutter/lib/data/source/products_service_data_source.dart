import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marketplace/core/constants/api_urls.dart';
import 'package:marketplace/core/network/dio_client.dart';
import 'package:marketplace/presentation/service_locator.dart';

abstract class ProductsServiceDataSource {
  Future<Either> getProductCategories();
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
}
