import 'package:dartz/dartz.dart';
import 'package:shoplify/data/models/favorite_product_params_model.dart';

abstract class FavoriteRepository {
  Future<Either> getFavoriteProducts(FavoriteProductParamsModel favoriteProductParamModel);
}
