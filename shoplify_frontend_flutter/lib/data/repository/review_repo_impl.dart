import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shoplify/data/models/review_model.dart';
import 'package:shoplify/data/models/review_param_model.dart';
import 'package:shoplify/data/source/review_service_data_source.dart';
import 'package:shoplify/domain/repository/review_repo.dart';
import 'package:shoplify/presentation/service_locator.dart';

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

  @override
  Future<Either> submitProductReview(
      SubmitReviewModel submitReviewParamModel) async {
    Either result = await sl<ReviewServiceDataSource>()
        .submitProductReview(submitReviewParamModel);
    return result.fold((error) {
      return Left(error);
    }, (data) async {
      Response response = data;
      return Right(response.data);
    });
  }
}
