import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:marketplace/core/constants/api_urls.dart';
import 'package:marketplace/core/network/dio_client.dart';
import 'package:marketplace/data/models/review_param_model.dart';
import 'package:marketplace/presentation/service_locator.dart';

abstract class ReviewServiceDataSource {
  Future<Either> getProductReviews(ReviewParamModel reviewParamModel);
}

class ReviewServiceImpl extends ReviewServiceDataSource {
  @override
  Future<Either> getProductReviews(ReviewParamModel reviewParamModel) async {
    try {
      Response response = await sl<DioClient>().get(
        "${ApiUrls.api}/${ApiUrls.products}/${reviewParamModel.productId}/${ApiUrls.reviews}/",
      );
      return Right(response);
    } catch (e) {
      return Left(e);
    }
  }
}
