import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/core/network/dio_client.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/presentation/service_locator.dart';

abstract class FavoriteProductsDataSource {
  Future<Either> getFavoriteProducts(
      FavoriteProductParamsModel favoriteProductParamModel);
}

class FavoriteProductsDataSourceImpl extends FavoriteProductsDataSource {
  @override
  Future<Either> getFavoriteProducts(
      FavoriteProductParamsModel favoriteProductParamModel) async {
    try {
      Response response = await sl<DioClient>().get(ApiUrls.favorites,
          queryParameters: favoriteProductParamModel.toMap());
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }
}
