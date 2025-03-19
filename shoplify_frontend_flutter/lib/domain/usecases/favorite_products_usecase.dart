import 'package:dartz/dartz.dart';
import 'package:shoplify/core/usecase/usecase.dart';
import 'package:shoplify/domain/repository/favorite_product_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';

class GetFavoriteProductUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<FavoriteRepository>().getFavoriteProducts(params);
  }
}
