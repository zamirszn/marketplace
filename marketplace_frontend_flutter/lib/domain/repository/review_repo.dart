import 'package:dartz/dartz.dart';
import 'package:marketplace/data/models/review_param_model.dart';

abstract class ReviewRepository {
  Future<Either> getProductReviews(ReviewParamModel reviewParamModel);
}
