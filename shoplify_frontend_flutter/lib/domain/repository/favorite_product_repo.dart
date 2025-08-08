import 'package:dartz/dartz.dart';
import 'package:shoplify/data/models/params_models.dart';

abstract class FavoriteRepository {
  Future<Either> getFavoriteProducts(FavoriteProductParamsModel favoriteProductParamModel);
}
