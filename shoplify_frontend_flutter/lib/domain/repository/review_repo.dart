import 'package:dartz/dartz.dart';
import 'package:shoplify/data/models/params_models.dart';
import 'package:shoplify/data/models/review_model.dart';

abstract class ReviewRepository {
  Future<Either> getProductReviews(ReviewParamModel reviewParamModel);
  Future<Either> submitProductReview(SubmitReviewModel submitReviewParamModel);
}
