import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shoplify/data/models/favorite_product_params_model.dart';
import 'package:shoplify/data/source/favorite_product_data_source.dart';
import 'package:shoplify/domain/repository/favorite_product_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';

class FavoriteRepositoryImpl extends FavoriteRepository {
  @override
  Future<Either> getFavoriteProducts(
      FavoriteProductParamsModel favoriteProductParamModel) async {
    Either result = await sl<FavoriteProductsDataSource>()
        .getFavoriteProducts(favoriteProductParamModel);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }
}
