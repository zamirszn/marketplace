import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marketplace/data/models/review_param_model.dart';
import 'package:marketplace/data/source/products_service_data_source.dart';
import 'package:marketplace/data/source/review_service_data_source.dart';
import 'package:marketplace/domain/repository/review_repo.dart';
import 'package:marketplace/presentation/service_locator.dart';

class ReviewRepositoryImpl extends ReviewRepository {
  @override
  Future<Either> getProductReviews(ReviewParamModel reviewParamModel) async {
    Either result =
        await sl<ReviewServiceDataSource>().getProductReviews(reviewParamModel);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }
}
