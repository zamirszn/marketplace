import 'package:dartz/dartz.dart';
import 'package:marketplace/core/usecase/usecase.dart';
import 'package:marketplace/domain/repository/products_repo.dart';
import 'package:marketplace/presentation/service_locator.dart';

class ProductsUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return sl<ProductsRepository>().getProductCategories();
  }
}
