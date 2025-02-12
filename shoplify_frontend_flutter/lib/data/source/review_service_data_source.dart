import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/core/network/dio_client.dart';
import 'package:shoplify/data/models/review_model.dart';
import 'package:shoplify/data/models/review_param_model.dart';
import 'package:shoplify/presentation/service_locator.dart';

abstract class ReviewServiceDataSource {
  Future<Either> getProductReviews(ReviewParamModel reviewParamModel);
  Future<Either> submitProductReview(SubmitReviewModel submitReviewParamModel);
}

class ReviewServiceDataSourceImpl extends ReviewServiceDataSource {
  @override
  Future<Either> getProductReviews(ReviewParamModel reviewParamModel) async {
    try {
      Response response = await sl<DioClient>().get(
          "${ApiUrls.api}/${ApiUrls.products}/${reviewParamModel.productId}/${ApiUrls.reviews}/",
          queryParameters: reviewParamModel.toMap());
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> submitProductReview(
      SubmitReviewModel submitReviewParamModel) async {
    try {
      Response response = await sl<DioClient>().post(
          "${ApiUrls.api}/${ApiUrls.products}/${submitReviewParamModel.productId}/${ApiUrls.reviews}/",
          data: submitReviewParamModel.toMap());
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }
}
