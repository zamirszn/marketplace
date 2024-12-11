import 'package:dartz/dartz.dart';
import 'package:shoplify/data/models/review_model.dart';
import 'package:shoplify/data/models/review_param_model.dart';

abstract class ReviewRepository {
  Future<Either> getProductReviews(ReviewParamModel reviewParamModel);
  Future<Either> submitProductReview(SubmitReviewModel submitReviewParamModel);
}
